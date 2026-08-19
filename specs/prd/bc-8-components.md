---
context: bc-8
title: "Component Management"
total_bcs: 28   # brand-new file — no range-collapsed entries; total_bcs == definitional_count
definitional_count: 28   # count of `#### BC-` headings in this file
last_updated: 2026-08-19
source_pass: F2
trace: |
  - v1.4.2 — F5 feature-level wording amendments (2026-08-19, component-mgmt; no BC
    added/removed/retired, no count change, 28/28): BC-8.4.005 CLARIFIED (O-CS-1) — pins the
    ACTUAL id-listing message all five mutating call sites emit on `ExactMultiple`
    (`Multiple components named "<name>" found (IDs: <ids>). Pass the numeric ID directly.`)
    in place of the prior, inaccurate deferral to BC-8.4.003's `Ambiguous` message shape.
    BC-8.3.002 AMENDED (behavioral, human-approved) — EC-8.3.002-1 changes `rename
    --all-projects` with zero project matches from exit 0 (silent no-op) to exit 64
    ("not found"), matching the single-project form's not-found behavior; implementer landing
    the matching code change in parallel. See ADR-0018 §1 for the companion O-CS-2
    exit-code-divergence documentation note (component-family numeric-id 404: exit 64 on
    `jr component edit/delete/rename`, exit 1 on `jr issue create/edit --component`).
  - v1.4.1 — F5 scoped-adversarial fix round (2026-08-17, component-mgmt): resolves findings
    F5-A-M1/F5-C-001 (human-adjudicated: UNION). BC-8.4.005 amended — H1 extended to state the
    `MatchResult::ExactMultiple` disposition is caller-specific; Behavior section corrected
    (previously implied a single universal "treat as Exact, no error" outcome for every
    caller, citing BC-2.1.015 as an equating precedent) to explicitly distinguish: mutating
    callers (`component edit`/`delete`/`--move-to`, BC-8.1.008 branch (0)) FAIL CLOSED, exit
    64, unchanged by this round; read/filter callers (`issue list --component`, bc-2-issue-
    read.md BC-2.1.018/019/021/022) UNION all duplicate ids into the composed JQL clause, new
    this round. New VP-COMPONENT-022 (cross-referencing the canonical UNION assertions in
    bc-2-issue-read.md). No new BC IDs; no count change (28/28). See bc-2-issue-read.md's own
    v1.4.1 trace entry for the full read-path amendment detail.
  - L1: GitHub issues #604 (jr component list/create/edit/delete), #608 (jr component rename)
  - F1: .factory/phase-f1-delta-analysis/delta-analysis-components.md
  - F1: .factory/phase-f1-delta-analysis/business-analyst-input-components.md
  - Research: .factory/research/component-delete-and-bulk-wire-2026-08-15.md (Q1 delete
    safety, Q2 bulk wire shape — the bulk wire shape itself is consumed by bc-3-issue-write.md
    §3.4, not this file; this file owns the `jr component` command group only)
  - Precedent structure: bc-5-boards-sprints.md (comparably-sized new command-group file);
    src/cli/team.rs / src/api/jira/teams.rs / src/cli/issue/helpers.rs::resolve_team_field /
    TeamCache (structural precedent quadruple cited by the F1 architect impact table)
  - Deferred (explicitly OUT of scope for this file): #607 (generalized multi-valued/negatable
    filter grammar retrofit — #606's `--component` filter lands via a pre-composed clause,
    see bc-2-issue-read.md §2.1, specifically to avoid needing #607); #609 (cross-issue
    component impact scan)
---

# BC-8 — Component Management

28 behavioral contracts across 4 subdomains: Component Read & CRUD (8.1), Component Delete
Safety (8.2), Component Rename (8.3), Name/ID Resolution & Disambiguation (8.4).

**Scope note**: `jr component` governs classic Jira Software/Core project components
(`/rest/api/3/component`, the `fields.components` array on an issue) — NOT Atlassian
Compass "Components" (a separate service/software-catalog product with its own API
surface). See EC-COMPONENT-3 in `edge-case-catalog.md` for the disambiguation rationale;
`jr component --help` text MUST NOT imply Compass scope.

**Cross-file consumers**: `issue create --component`/`issue edit --component` wire-shape
contracts live in `bc-3-issue-write.md` §3.4 (BC-3.4.022..025); the `issue list --component`
filter contracts live in `bc-2-issue-read.md` §2.1 (BC-2.1.018..022). Both consume this
file's §8.4 resolver contracts and the `Component.id` struct field added by BC-2.3.040.

---

## Subdomains

### 8.1 Component Read & CRUD

#### BC-8.1.001: `jr component list [--project KEY]` GETs `/rest/api/3/project/{key}/components`; renders table (id, name, description, lead, assigneeType)

**Confidence**: HIGH
**Source**: F1 delta analysis §2 Impact table; `src/cli/component.rs` (pending F4). **[SOFTENED
2026-08-15, pass-10 fix-burst — resolves LOW-1 found by adversarial spec-delta review pass 10]**
non-pagination is ASSUMED (standard `/project/{key}/components` endpoint behavior), pending F4
live verification — NOT confirmed by `.factory/research/component-delete-and-bulk-wire-2026-08-15.md`,
which is scoped only to Q1 (delete safety) and Q2 (bulk wire shape) and contains no discussion of
this endpoint's pagination behavior. **Previous version (superseded, retained for audit trail):**
"`.factory/research/component-delete-and-bulk-wire-2026-08-15.md` (endpoint confirmed
non-paginated)" — this citation was unsupported; the cited file never discusses
`GET /rest/api/3/project/{key}/components` pagination.
**Subject**: Component Management
**Output channel profile** **[NEW 2026-08-15, M6 fix-burst]**: 3 (Mixed — stdout for
table/JSON component data, stderr for hints/warnings such as the `--counts` per-component
enrichment-failure warning, BC-8.1.003, and the no-project exit-64 message, BC-8.1.004; per
CLAUDE.md's five output-channel profiles, "applies to most read commands"). BC-8.1.002
(`--output json`) and BC-8.1.003 (`--counts`) are output-mode/flag variants of this SAME
`list` command and inherit this same profile — `list` is one command, not three.
**Behavior**: `jr component list` GETs `/rest/api/3/project/{key}/components` (assumed
non-paginated, pending F4 live verification — standard `/project/{key}/components` behavior is
that the endpoint returns the full component set for the project in one response; no `startAt`/
`maxResults` handling is expected to be needed, unlike most Jira collection endpoints). `--project
KEY`
resolves the target project explicitly; when absent, resolution falls back to the
configured `.jr.toml` project (same precedence as every other `jr` command that accepts an
optional `--project`). Table columns, in order: `ID`, `Name`, `Description`, `Lead`,
`Assignee Type`. `description`/`lead` render as `-` when the API returns `null`/absent
(components created without a description or lead are common). Empty component list on a
project with zero components is a valid success (empty table, exit 0) — not an error.
**Edge Cases**:
- EC-8.1.001-1: Project has zero components → exit 0, empty table (header row only), no error.
- EC-8.1.001-2: `description`/`lead` fields absent on a component → render `-`, not `null`
  or an empty cell.
**Trace**: F1 delta analysis §2; precedent BC-X.8.005 (`list_projects` pagination — contrast:
this endpoint is NOT paginated)

---

#### BC-8.1.002: `jr component list --output json` returns array of full component objects

**Confidence**: HIGH
**Source**: JSON render invariant BC-7.3.010; `src/cli/component.rs` (pending F4)
**Subject**: Component Management
**Behavior**: `--output json` returns a JSON array on stdout, one object per component, with
ALL fields the API returned for that component (id, name, description, lead, assigneeType,
project — no field is dropped for JSON mode, unlike the table's `-` placeholder convention).
Routes through `output::render_json` (pretty-printed) per the JSON render invariant (#526).
Empty component list → `[]` on stdout, exit 0.
**Trace**: BC-7.3.010 (JSON render invariant); BC-8.1.001 (table-mode sibling)

---

#### BC-8.1.003: `jr component list --counts` enriches each row with `relatedIssueCounts`

**Confidence**: HIGH
**Source**: `.factory/research/component-delete-and-bulk-wire-2026-08-15.md` (endpoint
`GET /rest/api/3/component/{id}/relatedIssueCounts` cited as the `--counts` data source);
`src/cli/component.rs` (pending F4)
**Subject**: Component Management
**Behavior**: `--counts` issues one additional `GET /rest/api/3/component/{id}/
relatedIssueCounts` call PER component returned by the list GET (N+1 pattern — there is no
documented bulk-counts endpoint). Table gains an `Issues` column (integer). `--output json`
gains an `issueCount` integer field per component object. On a project with zero components,
`--counts` is a no-op (no extra HTTP calls — nothing to enrich). A `relatedIssueCounts` call
failure for one component (e.g. transient 5xx) does NOT abort the whole listing — that row's
`Issues` cell renders `?` (table mode) / `issueCount: null` (JSON mode) and a stderr warning
is emitted naming the component; the command still exits 0 (fail-soft enrichment, same
posture as `--assets` column enrichment failures elsewhere in `jr`).
**Edge Cases**:
- EC-8.1.003-1: `--counts` on a zero-component project → zero extra HTTP calls, empty table.
- EC-8.1.003-2: One component's `relatedIssueCounts` call fails (5xx) → that row shows `?`
  (table) / `null` (JSON); stderr warning; exit 0; the other components' counts still render.
**Verification Properties**:
- VP-COMPONENT-001: `--counts` issues exactly one `relatedIssueCounts` GET per component in
  the list response (wiremock `.expect(N)` where N = component count); a plain `list` (no
  `--counts`) issues ZERO `relatedIssueCounts` calls (`.expect(0)`).
**Trace**: F1 delta analysis §2; research Q-context (`relatedIssueCounts` endpoint)

---

#### BC-8.1.004: `jr component list`/`edit`/`delete` (single-project forms) with no `--project` and no configured project → exit 64 (numeric-id edit/delete are exempt — see EC-8.1.004-6..8)

**[UPDATED 2026-08-15, H2 fix-burst — resolves a contradiction found by adversarial
spec-delta review pass 1]** Scope narrowed from "all five subcommands" to "the four
subcommands that use the single-project `--project`-or-config-fallback model." **Previous
version (superseded, retained for audit trail):** "`--project` is absent AND no project is
configured in `.jr.toml`, `jr component list`/`create`/`edit`/`delete`/`rename` all exit 64
BEFORE any HTTP call..." — this blanket five-subcommand claim was internally contradicted by
two OTHER BCs in this same file: (a) BC-8.1.005 makes `--project` clap-REQUIRED on `create`
(not a config-fallback guard at all — an absent `--project` on `create` is caught by clap
itself, exit 2, and never reaches this BC's exit-64 logic); (b) BC-8.3.002's `rename
--all-projects` is DELIBERATELY project-less by design — the very feature this BC claimed
would exit 64 without `--project`. Corrected here to name only the four subcommands that
genuinely follow the fallback model, with explicit carve-outs for the other two cases.

**[CORRECTED 2026-08-15, P6 fix-burst — resolves HIGH-1 found by adversarial spec-delta
review pass 6]** Scope narrowed AGAIN, from "four subcommands" to "three": `list`, `edit`,
`delete`. `rename --project` is REMOVED from this BC's fallback-model framing entirely — it
never belonged here. **Previous version (superseded, retained for audit trail):** the P1
correction directly above still named "the four subcommands that use the single-project
`--project`-or-config-fallback model" and the Behavior section (below) listed `jr component
rename --project` as one of the commands this BC's exit-64 guard governs. This was
self-contradictory on its face — this BC's own exclusion-case list (below) simultaneously
said "this guard never fires for `rename` at all — `rename`'s no-scope case is entirely owned
by BC-8.3.005, not this BC" AND "`rename --project KEY` … is the one `rename` sub-case this BC
DOES cover" — and it contradicted BC-8.3.001 (`--project` is UNCONDITIONALLY REQUIRED on
`rename`'s single-project form, Precondition 1, with NO config-fallback and no numeric
exemption from supplying it) and BC-8.3.005 (`rename`'s no-scope case is an
APPLICATION-LEVEL `project.is_none() && !all_projects` guard, a mechanism this BC does not
own or share). Concrete divergence the contradiction produced: `jr component rename OLD NEW`
with a configured default project — this BC's "four subcommands" framing implied the
configured default would be consulted and the rename would proceed, while BC-8.3.005 says
`rename`'s single-project form has no config-fallback at all and `--project`'s absence (with
`--all-projects` also absent) exits 64 regardless of any configured default. `rename` is not
a fourth member of this BC's fallback model — it has NO fallback model; its own scope
guard (BC-8.3.005) is a required-flag check, not a config-fallback check, and belongs to it
exclusively.

**Confidence**: HIGH
**Source**: Precedent BC-2.1.006 (`issue list` no-project-no-filters guard); `src/cli/component.rs` (pending F4)
**Subject**: Component Management
**Behavior** **[CORRECTED 2026-08-15, P6 fix-burst — resolves HIGH-1 found by adversarial
spec-delta review pass 6]**: When `--project` is absent AND no project is configured in
`.jr.toml`, `jr component list`, `jr component edit`, and `jr component delete` exit 64
BEFORE any HTTP call, with a message naming `--project` and `jr init`/config-file
remediation — **except** for the NUMERIC-ID EXEMPTION on `edit`/`delete` described
immediately below. This mirrors the "no default scope" philosophy already established by
BC-2.1.006 for `issue list` — component listing/mutation is always project-scoped and `jr`
never silently guesses which project — but the exemption recognizes that a numeric `NAME|ID`
on `edit`/`delete` never needed project scoping to begin with: `GET`/`PUT`/
`DELETE /rest/api/3/component/{id}` (BC-8.1.007, BC-8.2.002) address the component by its own
globally-unique numeric id, not by a project-scoped URL, so there is no ambiguity for this
guard to prevent in that one case. `rename` — including its single-project `--project` form —
is NOT governed by this guard at all; see exclusion case 2 below and BC-8.3.005, which owns
`rename`'s scope-selection requirement via its own application-level check, not a
config-fallback. **Previous version (superseded, retained for audit trail; P4 fix-burst):**
"...`jr component list`, `jr component edit`, `jr component delete`, and `jr component rename
--project` (the SINGLE-project form of `rename`) exit 64 BEFORE any HTTP call..." — this
wrongly included `rename --project` as a fourth fallback-model member. It directly
contradicted this same BC's own exclusion case 2 (which stated "this guard never fires for
`rename` at all") and BC-8.3.001 (`--project` is UNCONDITIONALLY REQUIRED on `rename`, no
config-fallback) and BC-8.3.005 (`rename`'s no-scope case is an independent app-level
`project.is_none() && !all_projects` guard that does not consult a configured default
project). Concrete divergence: `jr component rename OLD NEW` with a configured default
project — the superseded wording implied the configured default would be consulted and the
rename would proceed, while BC-8.3.005 exits 64 regardless of any configured default, since
`rename`'s single-project form requires `--project` to be explicitly supplied, full stop.
**Previous version (superseded, retained for audit trail; P1 fix-burst):** "...all exit 64
BEFORE any HTTP call..." — the unconditional "all" contradicted BC-8.1.008 EC-8.1.008-1 (`jr
component edit 10042` with no `--project` proceeding via the numeric bypass), BC-8.2.001
EC-8.2.001-4 (`jr component delete 999999999` with no disposition and no `--project` reaching
the disposition-guard message, which requires this BC to NOT have already exited 64 first),
and BC-8.2.002 Precondition 3/M1 (a numeric delete source treating `--project` as optional,
compared only if supplied) — all three assumed the numeric-bypass path on `edit`/`delete`
proceeds without a `--project`/configured project. This BC's blanket wording never said so.
Corrected below.
**NUMERIC-ID EXEMPTION [NEW 2026-08-15, P4 fix-burst]**: On `edit`/`delete` ONLY, when the
`NAME|ID` positional is all-ASCII-digit, this guard does NOT fire — the numeric bypass
(BC-8.1.008, BC-8.4.001 step 1) proceeds even with `--project` absent and no configured
project. `--project`, if supplied alongside a numeric `NAME|ID` on `delete`, is not discarded —
it is compared against the id's actual project once BC-8.2.002's M1 confirming `GET` resolves
it (mismatch → exit 64 pre-flight, per BC-8.2.002); it is simply not REQUIRED the way it is for
a NAME. A non-numeric NAME `NAME|ID` on `edit`/`delete` is UNAFFECTED by this exemption and
still requires `--project`/config exactly as before (name resolution is inherently
project-scoped — §8.4 — so this guard's rationale fully applies there). `list` and `create`
are also unaffected — `list` has no `NAME|ID` positional to exempt, and `create` was already
excluded (case 1 below) for an unrelated reason (clap-required, not config-fallback).
**This guard explicitly EXCLUDES three cases, each governed by its own BC instead:**
1. `jr component create` — `--project` is clap-REQUIRED (BC-8.1.005), not config-fallback.
   An absent `--project` on `create` is a clap parse error (exit 2), never reaching this
   exit-64 guard. `create` has no "configured default project" fallback at all (BC-8.1.005's
   Behavior: "unlike `list`/`edit`/`delete`, creation has no safe default project to guess").
2. `jr component rename` in EITHER form — `--project KEY` or `--all-projects` — is entirely
   outside this BC's scope, not merely its `--all-projects` variant. **[CORRECTED 2026-08-15,
   P6 fix-burst — resolves HIGH-1 found by adversarial spec-delta review pass 6]** `rename
   --all-projects` is deliberately project-LESS by design (BC-8.3.002); `rename --project KEY`
   requires `--project` unconditionally with NO config-fallback (BC-8.3.001 Precondition 1).
   `rename` without EITHER `--project` OR `--all-projects` exits 64 via BC-8.3.005's
   application-level `project.is_none() && !all_projects` guard (a DIFFERENT mechanism from
   this BC — a required-flag check, not a configured-project fallback check). THIS BC's guard
   never fires for `rename` at all, in either form — `rename`'s scope-selection is entirely
   owned by BC-8.3.005, and its numeric-`OLD` project-mismatch check is entirely owned by
   BC-8.3.001 M1. **Previous version's closing parenthetical (superseded, retained for audit
   trail):** "(`rename --project KEY` with no config fallback needed — `--project` was
   supplied — is the one `rename` sub-case this BC DOES cover, per the title.)" — this directly
   contradicted the sentence immediately preceding it in the same case ("THIS BC's guard never
   fires for `rename` at all") and contradicted BC-8.3.001/BC-8.3.005, which own 100% of
   `rename`'s scope-guard logic with no case ever routing through this BC. Removed; the title
   no longer references `rename` (P6 fix-burst).
3. **[NEW 2026-08-15, P4 fix-burst; UPDATED 2026-08-15, P5 fix-burst — resolves MED-1/LOW-1
   found by adversarial spec-delta review pass 5]** A numeric `NAME|ID` on `edit`/`delete` —
   per the NUMERIC-ID EXEMPTION above, this guard never fires for that input shape regardless
   of `--project`/config state; the numeric bypass's own confirming `GET`/`PUT`/`DELETE` call
   (BC-8.1.008, BC-8.1.007 M1, BC-8.2.002 M1) is the only check that runs — and for `edit`, that
   confirming `GET` now also DERIVES the component's actual project when none was
   supplied/configured (BC-8.1.007 M1, new), used for `--lead` resolution (BC-8.1.006) and
   cache invalidation (ADR-0018 §2). `rename`'s `OLD` positional is still NOT included in this
   EXEMPTION — the single-project form of `rename` (BC-8.3.001 Precondition 1) requires
   `--project KEY` unconditionally, whether or not `OLD` happens to be numeric; `rename` has no
   config-fallback case to exempt FROM in the first place (BC-8.3.005's `ArgGroup` owns its
   no-scope case, per exclusion case 2 above). **Previous version's closing clause (superseded,
   retained for audit trail):** "...since `rename` has no analogous 'compare-if-supplied'
   mechanism the way `delete`'s numeric-source confirmation (BC-8.2.002 M1) does" — this was
   accurate before the P5 fix-burst closed the LOW-1 gap (a numeric `OLD` silently renaming a
   component in an unrelated project when `--project` mismatched, with no check to catch it);
   `rename` now DOES have this mechanism (BC-8.3.001 M1, new) — a numeric `OLD`'s confirming
   `GET` derives the actual project and compares it against the REQUIRED `--project KEY`,
   mismatch → exit 64 pre-flight, symmetric with `delete`'s SOURCE confirmation.
**Edge Cases**:
- EC-8.1.004-1: `--project` supplied → guard does not fire regardless of config state.
- EC-8.1.004-2 **[SCOPED 2026-08-15, P6 fix-burst — resolves HIGH-1 found by adversarial
  spec-delta review pass 6]**: `--project` absent but `.jr.toml` has a configured project →
  on `list`/`edit`/`delete` ONLY, guard does not fire and the configured project is used.
  Explicitly does NOT apply to `rename` in either form — `rename --project KEY` has no
  config-fallback at all (BC-8.3.001 Precondition 1 requires `--project` to be supplied
  literally, a configured default does not satisfy it) and `rename --all-projects` does not
  consult a configured project either (BC-8.3.002).
- EC-8.1.004-3 **[NEW 2026-08-15, H2 fix-burst]**: `jr component create NAME` (no `--project`,
  no config) → clap exit 2 (missing required argument), NOT this BC's exit 64 — `create` never
  reaches this guard's logic path.
- EC-8.1.004-4 **[NEW 2026-08-15, H2 fix-burst]**: `jr component rename OLD NEW --all-projects`
  (no `--project`, no config) → proceeds normally, zero guard interaction — `--all-projects`
  is a complete, valid scope selector on its own (BC-8.3.002), not a trigger for this BC.
- EC-8.1.004-5 **[NEW 2026-08-15, H2 fix-burst]**: `jr component rename OLD NEW` (neither
  `--project` nor `--all-projects`, no config) → exit 64 via BC-8.3.005's `ArgGroup` guard,
  NOT this BC — the two guards produce the same user-visible outcome (exit 64, `--project`
  named) but are mechanically distinct (clap `ArgGroup` vs. this BC's config-fallback check).
- EC-8.1.004-6 **[NEW 2026-08-15, P4 fix-burst; UPDATED 2026-08-15, P5 fix-burst]**: `jr
  component edit 10042` (no `--project`, no config) → guard does not fire (NUMERIC-ID
  EXEMPTION); proceeds to BC-8.1.008's numeric bypass, which now (P5 fix-burst) fires a
  confirming `GET /rest/api/3/component/10042` (BC-8.1.007 M1) to derive the component's
  actual project — used for `--lead` resolution and cache invalidation if `--lead` was also
  supplied — before BC-8.1.007's `PUT`. Matches BC-8.1.008 EC-8.1.008-1 verbatim.
- EC-8.1.004-7 **[NEW 2026-08-15, P4 fix-burst]**: `jr component delete 999999999` (no
  `--project`, no config, no disposition) → guard does not fire (NUMERIC-ID EXEMPTION);
  falls through to BC-8.2.001 Postcondition 1's disposition guard, which fires instead (exit 64,
  disposition-guard message, not this BC's message). Matches BC-8.2.001 EC-8.2.001-4 verbatim.
- EC-8.1.004-8 **[NEW 2026-08-15, P4 fix-burst]**: `jr component edit Backend` (NAME, not
  numeric; no `--project`, no config) → guard FIRES (exit 64) — the exemption is numeric-input
  only; a name still requires project scoping to resolve at all.
**Trace**: BC-2.1.006 (structural precedent — "no default scope" philosophy); BC-8.1.005
(create's clap-required exclusion); BC-8.3.002, BC-8.3.005 (rename's `--all-projects`
exclusion and its own ArgGroup guard); BC-8.1.008 (numeric-bypass mechanics the exemption
defers to); BC-8.2.001, BC-8.2.002 (delete's disposition guard and numeric-source project
confirmation, both of which assume this exemption)

---

#### BC-8.1.005: `jr component create --project KEY NAME [--description D] [--lead NAME] [--assignee-type TYPE]` POSTs `/rest/api/3/component`

**Confidence**: HIGH
**Source**: F1 delta analysis §2 (endpoint confirmed); `src/cli/component.rs` (pending F4)
**Subject**: Component Management
**Output channel profile** **[NEW 2026-08-15, M6 fix-burst]**: 4 (Symmetric — stdout for
`--output json` success data, stderr for the table-mode confirmation line and any error, per
CLAUDE.md's five output-channel profiles; same profile as the sibling state-changing
`comment delete` command, BC-3.5.002).
**Behavior**: `--project KEY` is REQUIRED on `create` (clap-required, not config-fallback —
unlike `list`/`edit`/`delete`, creation has no safe default project to guess and an accidental
wrong-project create is a real component permanently attached to the wrong project).
`NAME` is a required positional. `POST /rest/api/3/component` body: `{"name": NAME, "project":
KEY, "description": D (if supplied), "leadAccountId": <resolved accountId> (if `--lead`
supplied), "assigneeType": TYPE (if supplied, one of Jira's enum: `PROJECT_LEAD`,
`COMPONENT_LEAD`, `UNASSIGNED`, `PROJECT_DEFAULT`)}`. Absent optional flags are omitted from
the body entirely (not sent as `null`). On success (201), `--output json` returns
`{"id": "<id>", "name": "<name>", "project": "<key>"}`; table mode echoes a one-line stderr
confirmation `Created component "<name>" (id <id>) in project <key>.`.
**Edge Cases**:
- EC-8.1.005-1: `NAME` collides with an existing component name in the same project → Jira
  400 surfaced verbatim (not pre-validated client-side — consistent with BC-8.3.007's
  rename-collision precedent; avoids a second round-trip for a case the server already
  validates authoritatively).
- EC-8.1.005-2 **[CORRECTED 2026-08-15, H2 fix-burst — exit-code class fix, DEC-188]**:
  `--assignee-type` supplied with a value outside the four-member enum → exit 2 pre-flight
  (clap `value_parser`/`ValueEnum` rejection, zero HTTP) — a clap enum-validation rejection is
  ALWAYS exit 2, never the app's own exit 64 (DEC-188's exit-code class), the same way an
  out-of-range `--output` value or any other clap `ValueEnum` flag in this codebase already
  behaves. **Previous version (superseded, retained for audit trail):** "exit 64 pre-flight
  (clap `value_parser` enum validation, zero HTTP)" — the MECHANISM (clap `value_parser`
  enum validation, zero HTTP) was correct; only the attributed EXIT CODE was wrong. `jr`
  deliberately keeps `--assignee-type` as a clap `ValueEnum` (rather than adding an
  app-level guard to force exit 64) because this is an ordinary flag-value validation with no
  destructive/ambiguous-scope semantics attached — the same posture every other clap-enum flag
  in this codebase already takes.
**Verification Properties**:
- VP-COMPONENT-022 **[NEW 2026-08-15, M10 fix-burst]**: `POST /rest/api/3/component` body
  contains `leadAccountId`/`description`/`assigneeType` keys ONLY when the corresponding flag
  was supplied — an absent `--description`/`--lead`/`--assignee-type` produces NO key in the
  body (never sent as `null`; wiremock body-match asserting the omitted key is entirely
  absent, not merely `null`); when all three are supplied, the body contains exactly `name`,
  `project`, `description`, `leadAccountId`, `assigneeType` and no other keys.
**Trace**: F1 delta analysis §2 (component resource shape: id, name, description, lead,
assigneeType, project)

---

#### BC-8.1.006: `--lead <NAME>` resolves display name to `accountId`; ambiguous or no-match aborts BEFORE the mutating HTTP call

**Confidence**: HIGH
**Source**: Precedent BC-X.7.004 (duplicate-display-name handling), BC-3.1.002 (`issue assign
--to <name>` resolution pattern); `src/cli/component.rs` (pending F4)
**Subject**: Component Management
**Behavior**: `--lead <NAME>` (on both `create` and `edit`) resolves via the existing
assignable-user search machinery (`search_assignable_users_by_project` scoped to the target
project, same resolver `issue assign --to <name>` already uses) to a single `accountId`,
sent as `leadAccountId` on the wire (GDPR-era Jira Cloud field name — never `name` or
`key`). Resolution happens BEFORE the create/edit HTTP call fires. Zero matches or 2+
ambiguous matches (duplicate display names, per BC-X.7.004) → exit 64 listing the candidate
emails/accountIds; no POST/PUT is issued (no partial create/edit with a missing lead).
`--lead ""` (empty string) is a distinct, valid signal on `edit` ONLY (see BC-8.1.007).

**Target project for numeric `edit` [NEW 2026-08-15, P5 fix-burst — resolves MED-1 found by
adversarial spec-delta review pass 5]**: On `create`, "the target project" scoping the
assignable-user search above is always `--project KEY` (clap-required, BC-8.1.005) —
unambiguous. On `edit` with a NAME positional, "the target project" is whichever project §8.4's
name resolution was already scoped to (flag or config fallback) — also unambiguous. On `edit`
with a NUMERIC `NAME|ID` and no `--project`/config supplied, there was previously no project
available to scope `--lead`'s search against at all. This is resolved by BC-8.1.007 M1's
numeric-source project-derivation mechanism (new, P5 fix-burst): the SAME confirming `GET
/rest/api/3/component/{id}` BC-8.1.008 already fires to confirm the id's existence also has its
`project` field read, and that field becomes "the target project" for `--lead` resolution in
this case. A supplied `--project KEY` that mismatches the derived project exits 64 pre-flight
(BC-8.1.007 M1) BEFORE `--lead` resolution is attempted, so this resolver never runs against a
stale or wrong project.
**[CORRECTED 2026-08-15, H2 fix-burst — exit-code class fix, DEC-188]** `create --lead ""` is
rejected by an explicit APPLICATION-LEVEL guard (`JrError::UserError`, exit 64), evaluated
immediately after clap parsing and before any HTTP: clap's `String`-typed `--lead` value
parser does NOT reject an empty string on its own (an empty string is a perfectly ordinary,
valid `String`), so this guard cannot be — and is not — a clap mechanism. `jr` checks
`subcommand == create && lead == Some("")` and, if true, returns exit 64,
`"--lead \"\" has no effect on create — there is no existing lead to clear. Omit --lead, or
supply a name."`, before any POST fires. **Previous version (superseded, retained for audit
trail):** "`create --lead \"\"` is rejected at the clap level as a degenerate empty positional
value (exit 64)" — clap does not reject empty strings; there is no "degenerate empty
positional value" mechanism in clap for a `String`-typed option. The user-visible outcome
(exit 64, no HTTP) is unchanged; the mechanism producing it is corrected to an app-level
guard.

**Known limitation [NEW 2026-08-15, M7 fix-burst]**: Jira's component-lead field itself only
requires the assignee to have BROWSE permission on the project — a strictly LARGER
population than "assignable" (a user must additionally be a valid issue assignee to appear in
`search_assignable_users_by_project`'s results). This means a real Jira user who is a valid
component-lead candidate (browse permission, e.g. a stakeholder or reporter-only role) but
who is NOT independently assignable to issues in that project (no assignable permission) is
UNREACHABLE via `--lead <NAME>` — the resolver will report "no user matching" for a name that
Jira's own UI would happily accept as a lead. This is a DELIBERATE, documented limitation for
this cycle, not a bug: `jr` reuses the existing `search_assignable_users_by_project` resolver
(the same one `issue assign --to` already uses) rather than introducing a new,
permission-broader user-search code path solely for this one field — a general
browse-permission-scoped user search is not an existing capability in this codebase and would
require new API surface, new caching, and its own resolver contract, which is out of scope for
this cycle's component-management bundle. **Workaround**: a user unreachable via `--lead` must
be set as component lead through the Jira web UI directly; `jr component create`/`edit` can
still be used for every other field, then the lead set separately in the UI.
**Invariants**:
1. Lead resolution NEVER partially completes a create/edit — either it fully resolves to
   exactly one `accountId` before the mutating call, or the command exits 64 with zero
   mutating HTTP calls.
2. **[NEW 2026-08-15, M7 fix-burst]** `--lead`'s resolver population is a SUBSET of Jira's own
   valid component-lead population (assignable users ⊆ browse-permission users) — this
   resolver can produce a false-negative "no user matching" for a name that would be a valid
   lead in the Jira UI, per the Known limitation above. It can never produce a false-POSITIVE
   (every resolved `accountId` IS a valid lead, since assignable implies browse-eligible on
   every Jira Cloud permission scheme this codebase assumes).
**Edge Cases**:
- EC-8.1.006-1: `--lead "Ambiguous Name"` matching 2+ users → exit 64, stderr lists
  candidates by email + accountId (BC-X.7.004 message shape); no POST/PUT issued.
- EC-8.1.006-2: `--lead "Nobody"` matching zero users → exit 64, `"No user matching 'Nobody'"`
  (mirrors BC-3.1.002's not-found shape); no POST/PUT issued.
- EC-8.1.006-3 **[NEW 2026-08-15, H2 fix-burst]**: `jr component create --project KEY NAME
  --lead ""` → exit 64 via the app-level empty-lead-on-create guard (Behavior), zero POST
  calls — distinct from EC-8.1.006-1/2 (no resolver search is even attempted; the guard fires
  on the literal empty string before resolution begins).
**Verification Properties**:
- VP-COMPONENT-002: Ambiguous/no-match `--lead` on `create` issues zero
  `POST /rest/api/3/component` calls (`.expect(0)`); same on `edit` for `PUT` (`.expect(0)`).
  **[EXTENDED 2026-08-15, H2 fix-burst]** `create --lead ""` (EC-8.1.006-3) is included in
  this zero-`POST` pin — the app-level empty-lead-on-create guard fires before the resolver
  search this VP otherwise covers.
**Trace**: BC-X.7.004; BC-3.1.002; F1 delta analysis §2 (Validated API facts: `leadAccountId`,
GDPR, empty string clears)

---

#### BC-8.1.007: `jr component edit NAME|ID [--project KEY] [--name N] [--description D] [--lead NAME]` PUTs `/rest/api/3/component/{id}`; only supplied fields are sent

**Confidence**: HIGH
**Source**: F1 delta analysis §2 (endpoint confirmed: `PUT /rest/api/3/component/{id}`,
partial update, rename keeps id); `src/cli/component.rs` (pending F4)
**Subject**: Component Management
**Output channel profile** **[NEW 2026-08-15, M6 fix-burst]**: 4 (Symmetric — stdout for
`--output json` success data, stderr for the field-echo confirmation lines and any error, per
CLAUDE.md's five output-channel profiles; same profile as BC-8.1.005 `create` and BC-3.5.002).
**Behavior**: `NAME|ID` positional identifies the target component (resolved per §8.4).
`PUT /rest/api/3/component/{id}` body contains ONLY the fields the user explicitly supplied —
`--name`, `--description`, `--lead` each independently gate their own body key (`name`,
`description`, `leadAccountId` respectively); an unsupplied flag is absent from the body, NOT
sent as its current/unchanged value (Jira's PUT is a partial update — omitted keys are left
untouched server-side, confirmed by the research file's "partial update" note). At least one
of `--name`/`--description`/`--lead` MUST be supplied, or the command exits 64 before any
HTTP call ("no fields specified to update" — mirrors `issue edit`'s equivalent guard).
`--lead ""` (empty string, `edit` only) sends `"leadAccountId": null`, explicitly clearing the
lead (per the research file's confirmed GDPR-era "empty string clears" semantics) — this is
DISTINCT from omitting `--lead` entirely (which leaves the existing lead untouched).
On success, `--output json` returns `{"id": "<id>", "name": "<name>", "project": "<key>"}`
(same shape as create); table mode echoes one stderr line per changed field, mirroring
`issue edit`'s `field → value` echo convention (BC-3.4.012) at the command-group level, not
literally routing through the same code path.

**Numeric-source project derivation (M1) [NEW 2026-08-15, P5 fix-burst — resolves MED-1/LOW-1/
LOW-3 found by adversarial spec-delta review pass 5]**: When the `NAME|ID` positional is
numeric, `jr` fires ONE confirming `GET /rest/api/3/component/{id}` — the SAME single-resource
GET BC-8.1.008's numeric bypass already requires to confirm the id's existence before the
`PUT` fires — and additionally reads its `project` field, mirroring BC-8.2.002 M1's
numeric-SOURCE confirmation on `delete` exactly (same mechanism, same shape of call, reused
across `edit`/`delete`'s numeric paths, not duplicated logic). The derived `project` becomes
the "known project key" for this invocation: it is used (1) to scope `--lead`'s
assignable-user search (BC-8.1.006's "Target project for numeric `edit`" note), and (2) as
`project_key` for `invalidate_components_cache(profile, project_key)` per ADR-0018 §2's
cache-invalidation contract. If `--project KEY` was ALSO supplied on the command line and it
does NOT match the GET's `project` field, `jr` exits 64 pre-flight (`"Component <id> belongs to
project <actual>, not <KEY>."`) — ZERO mutating HTTP calls, matching BC-8.2.002 M1's mismatch
message shape verbatim. If the confirming `GET` itself 404s (the numeric id does not exist),
this is the ORDINARY not-found path (BC-8.1.008), exit 64 — NOT a race/`ApiError`; see the
Idempotency section below for the race-vs-not-found distinction on the follow-up `PUT`. **[
CORRECTED 2026-08-15, P6 fix-burst — resolves MEDIUM-1 found by adversarial spec-delta review
pass 6]** Which of BC-8.1.008's two not-found message variants is used depends on whether a
`--project KEY` was ALSO supplied on the command line (or a project is configured), NOT solely
on the fact that the confirming `GET` is the call that 404d: if `--project`/config was known
going in, the project-qualified message is used with that KNOWN value — the 404'd `GET` failing
to independently confirm it does not erase a value the user (or config) already supplied; only
when NO `--project`/config was known at all does the project-less variant apply (BC-8.1.008's
Behavior, corrected P6 fix-burst). **Previous version (superseded, retained for audit trail;
P5 fix-burst):** "...using the project-less message variant … since no project could be
derived" — this always attributed the project-less variant to a 404'd confirming `GET`,
regardless of whether `--project` was independently supplied, overlapping BC-8.1.008's
project-qualified branch for `edit 999999 --project ENG` (see EC-8.1.007-6, new).

**Config-default-project scope [NEW 2026-08-15, P9 fix-burst — documentation parity with
BC-8.2.002's identical note]**: mirroring BC-8.2.002 M1's own "Config-default-project scope"
note in substance: this mismatch check compares the confirming `GET`'s `project` field against
an explicitly-supplied `--project KEY` FLAG value ONLY — it does NOT separately check against a
`.jr.toml` configured default project when `--project` is absent from the command line. This is
deliberate, not an oversight, for the same reason BC-8.2.002 documents: the confirming `GET`'s
own `project` field is UNCONDITIONALLY authoritative for scoping `--lead` resolution and cache
invalidation regardless of what `--project` or config says, so a config-default mismatch cannot
cause `edit` to act against the wrong project the way an unchecked flag mismatch could — there
is no flag-mismatch case a config check could additionally guard. A config-default/actual-
project mismatch on a numeric `NAME|ID` is silently tolerated (the GET's confirmed project is
used regardless); a future enhancement MAY extend this check to the config-default case for UX
parity, out of scope here.

A NAME `NAME|ID` is UNAFFECTED — name resolution (§8.4) is already
inherently scoped to whichever project `--project KEY` (or its config-fallback) supplies, so
there is no analogous derivation needed (identical posture to BC-8.2.002 M1's own "name path
unaffected" note).

**Preconditions** **[ORDERING NOTE CORRECTED 2026-08-15, P16 fix-burst — resolves MED-1 found by
adversarial spec-delta review pass 16]**: preconditions are checked IN THE LISTED ORDER —
Precondition 1 (at least one field flag supplied) is checked FIRST, before BOTH Precondition 2
(`NAME|ID` resolution, §8.4) AND Precondition 3 (the numeric-source confirming `GET`), so `jr
component edit <NAME-or-numeric>` with NO field flags fires ZERO HTTP calls regardless of
whether `NAME|ID` is a name or a numeric id — the "no fields specified" exit 64 fires before any
resolution attempt is made, not merely before the numeric-source confirming `GET`. See
EC-8.1.007-1 (name input) and EC-8.1.007-7 (numeric input). This is a DELIBERATE divergence from
`delete` (BC-8.2.001 Precondition 2: `NAME|ID` resolution runs regardless of which disposition
flag is or isn't supplied, so a bad `NAME|ID` is reported as not-found BEFORE the disposition
guard fires, per BC-8.2.001 Invariant 1) — `edit`'s no-fields guard is a pure-flag check with no
dependency on the target's existence or project, mirroring `issue edit`'s equivalent guard (see
Behavior above), so there is no reason to pay for a resolution GET (or, for a numeric id, a
confirming GET) before evaluating it. **Previous version (superseded, retained for audit trail;
P6 fix-burst):** "preconditions are checked IN THE LISTED ORDER — in particular, Precondition 2
(at least one field flag supplied) is checked BEFORE Precondition 3 (the numeric-source
confirming `GET`)" — this correctly ordered the (then-numbered) Precondition 2 ahead of
Precondition 3, fixing the numeric no-fields case (EC-8.1.007-7), but never addressed
Precondition 2 vs. the (then-numbered) Precondition 1 (`NAME|ID` resolution): for a NAME
`NAME|ID` on a cold component-list cache, §8.4 resolution — the prior Precondition 1 — fired a
`GET /project/{key}/components` BEFORE the no-fields check ran, contradicting this BC's own
Behavior text, EC-8.1.007-1, and VP-COMPONENT-023's zero-HTTP guarantee for the NAME case. Found
by adversarial spec-delta review pass 16 (MED-1). Corrected by promoting the no-fields check to
Precondition 1 (renumbering resolution to Precondition 2); the numeric-source confirming `GET`
remains Precondition 3 — its own number is unchanged, so existing cross-references to
"Precondition 3"/"Postcondition 3" elsewhere in this file remain accurate.
1. At least one of `--name`/`--description`/`--lead` is supplied.
2. `NAME|ID` resolves to exactly one component (§8.4).
3. **[NEW 2026-08-15, P5 fix-burst]** When `NAME|ID` is numeric, the confirming `GET
   /rest/api/3/component/{id}` (M1 above) has resolved the component's actual `project` field,
   and that field — not a bare `--project KEY` flag value — is the "known project key" `--lead`
   resolution (if `--lead` is supplied) and cache invalidation are scoped against; a supplied
   `--project KEY` that mismatches this field exits 64 pre-flight before `--lead` resolution or
   the `PUT` begins.
**Postconditions**:
1. `PUT /rest/api/3/component/{id}` body contains exactly the supplied fields' keys — no more,
   no fewer.
2. `--lead ""` → body contains `"leadAccountId": null`. Omitted `--lead` → body has no
   `leadAccountId` key at all.
3. **[NEW 2026-08-15, P5 fix-burst]** For a numeric `NAME|ID`, the confirming `GET`'s `project`
   field and a supplied `--project KEY` are compared; a mismatch exits 64, ZERO mutating HTTP
   calls (no `--lead` resolution, no `PUT`).
**Edge Cases**:
- EC-8.1.007-1 **[CLARIFIED 2026-08-15, P16 fix-burst — resolves MED-1 found by adversarial
  spec-delta review pass 16]**: `jr component edit foo` (NAME input, no field flags) →
  Precondition 1's "at least one field" check fires FIRST, exit 64, "no fields specified"
  message — ZERO HTTP calls, including ZERO §8.4 resolution `GET`, even on a cold
  component-list cache (§8.4 resolution is Precondition 2 and is never reached). Mirrors
  EC-8.1.007-7's numeric-input case below; both are now instances of the same
  Precondition-1-fires-first rule stated in the Preconditions ordering note above.
- EC-8.1.007-2: `--name` collides with an existing component name in the same project → Jira
  400 surfaced verbatim (same posture as create/rename — not pre-validated client-side).
- EC-8.1.007-3 **[NEW 2026-08-15, P5 fix-burst]**: `jr component edit 10042 --lead "Alice"`
  (numeric, no `--project`/config) → the confirming `GET /rest/api/3/component/10042` derives
  `"project": "ENG"`; `--lead "Alice"` resolves against `ENG`'s assignable users; on success,
  `PUT /rest/api/3/component/10042` fires with `{"leadAccountId": "<resolved>"}`; cache
  invalidation uses `project_key = "ENG"`. Resolves MED-1.
- EC-8.1.007-4 **[NEW 2026-08-15, P5 fix-burst]**: `jr component edit 10042 --project WRONG
  --name Foo` where `10042` actually belongs to `ENG` → confirming `GET` returns `"project":
  "ENG"`, mismatching `--project WRONG` → exit 64 pre-flight, `"Component 10042 belongs to
  project ENG, not WRONG."`, ZERO `PUT` calls.
- EC-8.1.007-5 **[NEW 2026-08-15, P5 fix-burst; SCOPED 2026-08-15, P6 fix-burst]**: `jr
  component edit 999999999 --name Foo` (numeric, nonexistent id, NO `--project` supplied and
  none configured) → the confirming `GET` 404s → exit 64, ordinary not-found path (BC-8.1.008),
  project-less message (no project was known by any source) — NOT exit 1/`ApiError` (that class
  is reserved for a race on the follow-up `PUT` AFTER a successful confirming `GET`; see
  Idempotency below).
- EC-8.1.007-6 **[NEW 2026-08-15, P6 fix-burst — resolves MEDIUM-1 found by adversarial
  spec-delta review pass 6]**: `jr component edit 999999999 --project ENG --name Foo`
  (numeric, nonexistent id, `--project ENG` supplied) → the confirming `GET` 404s → exit 64,
  ordinary not-found path (BC-8.1.008), but the PROJECT-QUALIFIED message this time —
  `"Component '999999999' not found in project ENG. Run: jr component list"` — because `--project
  ENG` was known independently of the 404'd `GET`. Contrast EC-8.1.007-5, where no `--project`
  was supplied and the project-less variant applies instead.
- EC-8.1.007-7 **[NEW 2026-08-15, P6 fix-burst — resolves INFO-1 found by adversarial
  spec-delta review pass 6; renumbered 2026-08-15, P16 fix-burst — resolves MED-1 found by
  adversarial spec-delta review pass 16]**: `jr component edit 10042` (numeric, NO field flags
  at all) → Precondition 1's "at least one field" check fires FIRST (exit 64, "no fields
  specified" message, mirrors EC-8.1.007-1's name-input case) — ZERO HTTP calls, including ZERO
  confirming `GET`. The numeric-source confirming `GET` (M1, Precondition 3) is never reached,
  since it only matters for `--lead` resolution and cache invalidation, both of which are moot
  when there is nothing to update. Matches EC-8.1.007-1's zero-HTTP intent, now explicitly
  extended to the numeric-input case. **[P16 fix-burst]** This guarantee is now STRENGTHENED
  alongside EC-8.1.007-1: Precondition 1 fires before Precondition 2 (§8.4 resolution) as well
  as before Precondition 3, closing the gap where a NUMERIC input's own resolution path (which,
  unlike NAME resolution, does not itself require an HTTP call until Precondition 3) was already
  zero-HTTP by construction, but the ordering note previously left the NAME case's Precondition
  1-vs-2 relationship unstated. (Precondition renumbering: what this edge case previously cited
  as "Precondition 2" is now Precondition 1; the numeric-source confirming `GET` remains
  Precondition 3, unchanged.)

**Idempotency / 404 taxonomy [NEW 2026-08-15, P5 fix-burst — resolves LOW-3 found by
adversarial spec-delta review pass 5]**: `edit`'s `NAME|ID` resolution failing outright — a NAME
matching zero/2+ components (§8.4), or a numeric id whose confirming `GET` (M1 above) 404s — is
the ORDINARY not-found/ambiguous exit-64 path (BC-8.1.008/BC-8.4.002/BC-8.4.003), never a race.
A `PUT` call that itself races and returns 404 (the component is deleted by a concurrent actor
between a SUCCESSFUL resolution/confirming-`GET` and the `PUT`) is surfaced as `ApiError(404)`
— exit 1 — distinct from the resolver/confirming-`GET`'s exit-64 not-found, since this is a
genuine race rather than a bad user-supplied `NAME|ID`. This mirrors BC-8.2.008's identical
delete-side taxonomy exactly (resolver-layer 404 → exit 64; mutating-call-layer 404 AFTER a
successful resolution → exit 1) — the same two-tier distinction, now stated for `edit`'s `PUT`
as well as `delete`'s `DELETE`.

**Verification Properties**:
- VP-COMPONENT-023 **[NEW 2026-08-15, M10 fix-burst]**: `PUT /rest/api/3/component/{id}`
  body contains EXACTLY the keys for the flags supplied — a wiremock body-match asserting
  `--name` alone → body is `{"name": "..."}` only (no `description`/`leadAccountId` keys,
  Postcondition 1); `--lead ""` → body contains `"leadAccountId": null` (Postcondition 2,
  explicit clear, distinct from an omitted `--lead` which sends no `leadAccountId` key at
  all); combining `--name`+`--lead ""` → body is exactly `{"name": "...", "leadAccountId":
  null}`, no `description` key.
- VP-COMPONENT-004 **[EXTENDED 2026-08-15, P5 fix-burst]**: this BC's M1 numeric-source
  project-confirmation mechanism reuses VP-COMPONENT-004's property (originally defined at
  BC-8.2.002 for `delete`, scope broadened here to `edit` too, alongside `rename`'s BC-8.3.001
  M1): a supplied `--project KEY` mismatching the confirming `GET`'s `project` field →
  `.expect(0)` on the `PUT` (EC-8.1.007-4).
- VP-COMPONENT-024 **[EXTENDED 2026-08-15, P5 fix-burst]**: see BC-8.2.008's VP-COMPONENT-024
  for the full statement; this BC's `PUT` shares the identical exit-code divergence
  (confirming-`GET`/resolver 404 → exit 64, EC-8.1.007-5; a `PUT` racing to 404 AFTER a
  successful resolution → exit 1) — a wiremock fixture pinning both paths for `edit` mirrors
  BC-8.2.008's dual-path fixture for `delete`.
**Trace**: F1 delta analysis §2; BC-8.1.006 (lead resolver reuse); BC-3.4.012 (field-echo
convention precedent, cited for pattern only — not a shared code path); BC-8.2.002 M1 (shared
numeric-source project-confirmation mechanism this BC's M1 mirrors); BC-8.2.008 (shared 404
taxonomy this BC's Idempotency section mirrors)

---

#### BC-8.1.008: Unknown component `NAME|ID` on `edit`/`delete`/`rename` → exit 64, taxonomy-consistent message; component `NAME|ID` accepted interchangeably with an all-digit numeric bypass

**Confidence**: HIGH
**Source**: CLAUDE.md Gotcha "`jr requesttype fields <NAME|ID>` numeric-bypass edge case"
(structural precedent); BC-2.7.006 (unknown-KEY taxonomy pattern); `src/cli/component.rs`
(pending F4)
**Subject**: Component Management
**Behavior**: The `NAME|ID` positional on `edit`/`delete` (and the `OLD` positional on
`rename`, see §8.3) is resolved via §8.4: all-ASCII-digit input short-circuits directly to
`GET /rest/api/3/component/{id}` (or is passed straight through as the numeric id for the
mutating call) WITHOUT consulting the project component list — this is the same numeric-
bypass convention `jr requesttype fields <NAME|ID>` already establishes, including its
documented escape-hatch gap: a component literally NAMED `"100"` is unreachable by name
through this positional (look it up by id via `jr component list --output json | jq`).
Non-digit input resolves by name via §8.4's scoped `partial_match` lookup. Either path
failing to resolve to exactly one component → exit 64, zero mutating HTTP calls, with the
message composed from whichever resolution path failed and, for the numeric path, whichever
project context is actually available (**[CORRECTED 2026-08-15, P7 fix-burst — resolves
MEDIUM-1 found by adversarial spec-delta review pass 7]**):
(0) a NAME `NAME|ID` (non-digit input) that fails resolution — zero matches or 2+ matches —
DEFERS ENTIRELY to §8.4's own contracts and does NOT restate a distinct message here: zero
matches → BC-8.4.002's `"Component '<input>' not found in project <key>. Available:
<comma-joined alphabetical list>."`; 2+ matches → BC-8.4.003's `"Ambiguous component '<input>'.
Matches: <candidates>."` This BC's `edit`/`delete` callers and BC-2.1.022's `issue list
--component` caller share the IDENTICAL `resolve_component` call for a NAME input — there is no
`edit`/`delete`-specific NAME-path message, and none of the numeric-only branches below (1)/(2)
apply to a NAME input.
(1) a numeric `NAME|ID` where a project is KNOWN going into the resolution attempt — i.e.
`--project KEY` was supplied on the command line, OR a project is configured in `.jr.toml`, OR a
project was already derived by a prior M1 confirming `GET` earlier in this same invocation — →
`"Component '<input>' not found in project <key>. Run: jr component list"`, using that KNOWN
project value as `<key>` (this branch applies REGARDLESS of whether the numeric id's OWN
confirming `GET` is the call that 404s — a supplied/configured project is known independently of
whatever that GET returns or fails to return, so its 404 does not erase it); (2) a numeric
`NAME|ID` with NO project known by any of the three sources above — no `--project` supplied, no
configured default, and none derived — whose OWN confirming `GET` (BC-8.1.007 M1 on `edit`,
BC-8.2.002 M1 on `delete`, BC-8.3.001 M1 on `rename`) is the very call that 404s → the
project-less variant, `"Component '<input>' not found. Run: jr component list --project <KEY> to
see valid components."` **Previous version (superseded, retained for audit trail; P6
fix-burst):** branches were numbered (1)/(2) only, and branch (1) additionally enumerated "a NAME
`NAME|ID`, OR a numeric `NAME|ID` where a project is KNOWN…" as a single combined case, assigning
the NAME sub-case the SAME `"...not found in project <key>. Run: jr component list"` message as
the numeric-known-project sub-case. This over-reached: BC-8.4.002 (zero-match) actually specifies
an `"Available: <list>"` suffix, and BC-8.4.003 (ambiguous) specifies an entirely different
`"Ambiguous component '<input>'. Matches: <candidates>."` message — neither of which this BC's
former branch (1) text produced, so `jr component edit BadName --project ENG` and `jr issue list
--component BadName --project ENG` (both routing through the identical `resolve_component` call)
would have emitted DIFFERENT messages for the same input/candidate set had this BC's text been
implemented literally. Found by adversarial spec-delta review pass 7 (MEDIUM-1). Corrected by
splitting the NAME sub-case out into new branch (0), which defers to BC-8.4.002/003 verbatim
instead of restating a message. **Previous version (superseded, retained for audit trail; P5
fix-burst):** branch (2) was defined as firing whenever "a numeric `NAME|ID` whose OWN confirming
`GET` … is the very call that 404s" — with NO condition on whether `--project` was independently
supplied. This overlapped branch (1) for the reachable case "numeric id + `--project` supplied +
confirming-GET 404s" (e.g. `jr component edit 999999 --project ENG`, or `rename`, which per
BC-8.3.001 Precondition 1 ALWAYS supplies `--project`): both branches' conditions were
simultaneously true, and the P5 wording resolved the overlap toward the project-less branch,
producing a message that tells the user to "specify a project" they had already specified.
Corrected: branch (2) is now conditioned on the ABSENCE of any known project (not merely on
which call happens to be the one that 404s), so a numeric id with a known `--project`/config
always gets the project-qualified message, whether or not the confirming `GET` was the failing
call. As a direct consequence, `rename` — which per BC-8.3.001 Precondition 1 always supplies
`--project` — can NEVER legitimately land in branch (2); see BC-8.3.001 EC-8.3.001-2 (corrected
in the same burst).
**Edge Cases**:
- EC-8.1.008-1: `jr component edit 10042` — all-digit → treated as component id directly
  (no name-list GET fired for resolution). **[NOTE 2026-08-15, P4 fix-burst]** This holds even
  with no `--project` supplied and none configured — BC-8.1.004's project-required guard carries
  an explicit numeric-ID exemption for `edit`/`delete` (see BC-8.1.004's NUMERIC-ID EXEMPTION
  and EC-8.1.004-6) precisely so this edge case is reachable.
- EC-8.1.008-2: `jr component edit "100"` where no component is named literally `"100"` and
  no component has id `100` in the resolved project scope → exit 64 not-found (the numeric
  bypass attempted id `100` and failed; a component literally named `"100"` is unreachable
  through this positional, matching the `requesttype fields` precedent verbatim).
- EC-8.1.008-3 **[NEW 2026-08-15, P5 fix-burst]**: `jr component edit 100` (numeric, no
  `--project`/config, no component with id `100` exists anywhere) → the confirming `GET
  /rest/api/3/component/100` (BC-8.1.007 M1) 404s → exit 64, the PROJECT-LESS message variant
  above (`"Component '100' not found. Run: jr component list --project <KEY> to see valid
  components."`) — no `<key>` clause, since the 404'd `GET` never derived one. Resolves LOW-3
  facet 2.
- EC-8.1.008-4 **[NEW 2026-08-15, P7 fix-burst — resolves MEDIUM-1 found by adversarial
  spec-delta review pass 7]**: `jr component edit BadName --project ENG` (NAME input, zero
  matches in scope) → branch (0) fires → exit 64, BC-8.4.002's verbatim message: `"Component
  'BadName' not found in project ENG. Available: <comma-joined alphabetical list>."` (NOT the
  numeric-branch message `"...Run: jr component list"`). `jr component edit Amb --project ENG`
  where `Amb` matches 2+ components → branch (0) fires → exit 64, BC-8.4.003's verbatim message:
  `"Ambiguous component 'Amb'. Matches: <candidates>."` `jr issue list --component BadName
  --project ENG` (a different consuming command, same shared `resolve_component` call) emits the
  BYTE-IDENTICAL message for the same input/candidate set (BC-2.1.022) — there is no
  `jr component`-specific NAME-path wording anywhere in this BC.
**Verification Properties [R-1, formal-verifier residual, resolved by cross-reference — no
dedicated VP minted]**: This BC mints no VP of its own; its three behaviors are pinned
transitively by sibling VPs already covering the identical resolver mechanics: the
all-digit-input numeric-bypass path (Behavior, EC-8.1.008-1) is the exact property
VP-COMPONENT-014 asserts (`resolve_component`'s numeric-id short-circuit — zero
`partial_match`/candidate-list GET on all-digit input); the NAME-path not-found/ambiguous exit
path (Behavior branch (0), EC-8.1.008-4) is the exact property VP-COMPONENT-009 asserts
(ambiguous/unknown name → zero mutating HTTP on the mutating consumers this BC's callers —
`edit`/`delete` — belong to), with the message SHAPE itself (not just the zero-HTTP property)
pinned at BC-8.4.002/BC-8.4.003's own Verification Properties sections and BC-2.1.022's
VP-COMPONENT-013 for the read-path caller. **[CORRECTED 2026-08-15, P7 fix-burst]** Previous
text here cited EC-8.1.008-2 (the quoted-numeric-literal `"100"` case) as "the non-digit
not-found/ambiguous exit path" — EC-8.1.008-2 is actually a digit-input case (the numeric
bypass attempting id `100`), not a NAME-path case; corrected to cite the newly-added
EC-8.1.008-4, which is the NAME-path case this paragraph actually describes. Decision: accepted
as sufficient transitive coverage rather than a duplicate pin, since `resolve_component` is a
single shared function and BC-8.1.008 introduces no resolution logic distinct from what
VP-014/VP-009/VP-013/BC-8.4.002's-own-VP/BC-8.4.003's-own-VP already exercise. **[NOTE
2026-08-15, P5 fix-burst]** The project-less-message EC (EC-8.1.008-3) and the uniform
confirming-GET-404-vs-mutating-call-404 exit-code taxonomy it belongs to are pinned at each
mutating command's own BC instead of here: `edit`'s in BC-8.1.007's Idempotency section
(VP-COMPONENT-024, extended); `delete`'s in BC-8.2.008's Idempotency section
(VP-COMPONENT-024, canonical); `rename`'s in BC-8.3.001's Idempotency section
(VP-COMPONENT-024, extended) — this BC remains the shared resolver-mechanics definition all
three cite, not a fourth duplicate pin.
**Trace**: CLAUDE.md Gotcha (`requesttype fields` numeric-bypass); BC-2.7.006; BC-8.4.001
(resolver mechanics); BC-8.1.007 M1, BC-8.2.002 M1, BC-8.3.001 M1 (P5 fix-burst — numeric-bypass
callers that now also derive/confirm a project via this BC's same confirming GET); BC-8.4.002,
BC-8.4.003 (P7 fix-burst — NAME-path zero-match/ambiguous messages this BC's branch (0) defers
to, verbatim, rather than restating); BC-2.1.022 (P7 fix-burst — sibling caller sharing the
identical resolver call and message shape for the NAME path)

---

### 8.2 Component Delete Safety

#### BC-8.2.001: `jr component delete NAME|ID [--project KEY]` refuses (exit 64) without EITHER `--move-to <NAME|ID>` OR `--orphan`

**Confidence**: HIGH
**Source**: `.factory/research/component-delete-and-bulk-wire-2026-08-15.md` §Q1.6
(RECOMMENDATION, adopted verbatim); ADR-0015 (`--resolution`/`--no-resolution` proactive-guard
shape, structural precedent); `src/cli/component.rs` (pending F4)
**Subject**: Component Management — delete safety (DEC-279)
**Output channel profile** **[NEW 2026-08-15, M6 fix-burst]**: 4 (Symmetric — stdout for
`--output json` success data (BC-8.2.008), stderr for the interactive confirm prompt
(BC-8.2.006), the table-mode confirmation echo, and any error; per CLAUDE.md's five
output-channel profiles; same profile as BC-8.1.005/BC-8.1.007/BC-3.5.002). Applies to `jr
component delete` as a whole (BC-8.2.001..008 are one command's guard/wire-shape contracts,
not separate profiles).
**Description**: Component deletion is permanent (research Q1.2: no component trash,
archive, or undelete endpoint exists on Jira Cloud) and its audit trail is not guaranteed
(research Q1.3: delete-cascade changelog entries are INCONCLUSIVE, not contractually
promised). `jr` therefore REFUSES to run `component delete` unless the caller has explicitly
chosen a disposition for the issues currently carrying the component — mirroring ADR-0015's
`--resolution`/`--no-resolution` requirement on `issue move` done-category transitions, which
established the same "never guess a destructive disposition" precedent in this codebase.
**Preconditions**:
1. `jr component delete NAME|ID [--project KEY]` is invoked.
2. `NAME|ID` resolves to exactly one component (§8.4) — this resolution happens regardless
   of which disposition flag is (or isn't) supplied, since the not-found/ambiguous case must
   be reported before the disposition guard, per Invariant 1.
**Postconditions**:
1. When NEITHER `--move-to` NOR `--orphan` is supplied: exit 64. Stderr names BOTH flags
   (`--move-to <NAME|ID>` and `--orphan`) — the message does NOT include an affected-issue
   count **[CORRECTED 2026-08-15, M3 fix-burst — resolves an ambiguity found by adversarial
   spec-delta review pass 2]**: BC-8.2.007's snapshot search (the sole source of the count) is
   scoped to fire only once a disposition has been chosen (see BC-8.2.007 Postcondition 1,
   corrected in the same burst) — it deliberately does NOT run in this no-disposition path, so
   there is nothing to spend an extra read-only search on for a request that is about to fail
   regardless. Zero `DELETE` calls issued, zero snapshot-search calls issued. **Previous
   version (superseded, retained for audit trail):** "...and, when the affected-issue count is
   cheaply knowable (see BC-8.2.006), includes it in the message" — this hedge implied the
   snapshot might sometimes fire in the no-disposition path; it never does, so the count is
   never available here and the hedge is removed rather than resolved either way.
2. `--move-to` and `--orphan` are clap-level mutually exclusive (supplying both → clap exit 2,
   before this guard's exit-64 logic is reached).
3. **[NEW 2026-08-15, P4 fix-burst — propagates BC-8.3.005's explicit DEC-188 mechanism note to
   this, its mechanically-identical sibling, per adversarial spec-delta review pass 4]** The
   NEITHER-flag exit-64 outcome (Postcondition 1) MUST be produced by an explicit
   APPLICATION-LEVEL guard (`JrError::UserError`, exit 64), evaluated immediately after clap
   parsing and before any HTTP — it MUST NOT be implemented as a clap `ArgGroup::required(true)`
   spanning `--move-to`/`--orphan`, because a required-group violation is ALWAYS a clap parse
   error (exit 2), never the app's own exit-64 convention (DEC-188's exit-code class). This is
   mechanically IDENTICAL to BC-8.3.005's `--project`/`--all-projects` split on `rename` — both
   BCs share the same two-guard shape: both-supplied → clap mutual exclusion (`conflicts_with`)
   → exit 2 (Postcondition 2 above); neither-supplied → app-level `JrError::UserError` check →
   exit 64 (Postcondition 1). BC-8.3.005 documents this mechanism note explicitly (citing this
   BC, BC-8.2.001, as the precedent its own split mirrors); this Postcondition closes the parity
   gap where the precedent BC lacked the same explicit note its own "mirrors" sibling carried.
**Invariants**:
1. The `NAME|ID` not-found/ambiguous check (§8.4) fires and is reported BEFORE the
   disposition guard — an unresolvable target reports "not found", not "missing --move-to/
   --orphan", even though both conditions are independently true. This ordering avoids a
   confusing error that references flags the user can't act on until the target itself is
   valid. **[DOCUMENTED EXCEPTION 2026-08-15, L1 fix-burst — pass 3, closes a gap found by
   adversarial spec-delta review pass 3]** This guarantee applies to NAME resolution ONLY. A
   NUMERIC `NAME|ID` that does not exist is a different case: BC-8.1.008's numeric bypass fires
   NO name-list GET for resolution purposes, and (per BC-8.2.002's M1 fix-burst scoping note) the
   numeric-source project-confirmation GET it introduced fires only once a disposition
   (`--move-to`/`--orphan`) has already been chosen — never in THIS BC's own no-disposition
   exit-64 path. Consequently `jr component delete 999999999` (a nonexistent numeric id,
   NEITHER `--move-to` nor `--orphan` supplied) has no HTTP call available to it that could
   discover the id doesn't exist before Postcondition 1's disposition-guard check runs, so it
   reports the disposition-guard message ("neither --move-to nor --orphan supplied"), NOT "not
   found" — the inverse of a name-based `NAME|ID` in the same neither-flag shape. This is a
   genuine, accepted asymmetry between the name and numeric paths in the no-disposition case
   specifically (not a defect to fix here): the numeric id's non-existence is instead
   discovered later, once a disposition IS supplied and the corresponding confirming GET/PUT/
   DELETE call runs (BC-8.2.008's Idempotency section).
2. There is no silent default disposition. Every `component delete` invocation either
   supplies exactly one of `--move-to`/`--orphan`, or exits 64.
**Edge Cases**:
- EC-8.2.001-1: `jr component delete Backend` (neither flag) → exit 64, both flags named,
  zero HTTP beyond the target-resolution GET.
- EC-8.2.001-2: `jr component delete Backend --move-to Frontend --orphan` → clap exit 2
  (mutual exclusion), before any resolution or HTTP.
- EC-8.2.001-3: `jr component delete Nonexistent --orphan` → exit 64 "not found" (Invariant
  1 ordering), NOT the disposition-guard message, even though `--orphan` alone would
  otherwise satisfy the guard. Contrast EC-8.2.001-4 (numeric, no disposition) below, where the
  reverse happens.
- EC-8.2.001-4 **[NEW 2026-08-15, L1 fix-burst — pass 3]**: `jr component delete 999999999`
  (all-digit, nonexistent id, NEITHER `--move-to` NOR `--orphan` supplied) → exit 64
  disposition-guard message (Postcondition 1), NOT "not found" — per Invariant 1's documented
  exception, no HTTP call in this neither-flag path can discover a numeric id's non-existence,
  so the disposition guard fires without ever learning the id doesn't exist. `jr component
  delete 999999999 --orphan` (disposition supplied), by contrast, DOES discover the
  non-existence — via whatever confirming call the chosen disposition triggers. **[EXIT CODE/
  MESSAGE SPECIFIED 2026-08-15, P5 fix-burst — resolves LOW-3 found by adversarial spec-delta
  review pass 5]** That confirming call is BC-8.2.002 M1's source-confirmation `GET
  /rest/api/3/component/999999999` (fired once `--orphan` is chosen, per BC-8.2.006
  Precondition 4); its 404 is the ORDINARY resolver-layer not-found (BC-8.1.008's Idempotency/
  404-taxonomy pointer, BC-8.2.008's Idempotency section), NOT a race — exit 64, the
  PROJECT-LESS message variant (BC-8.1.008, corrected P5 fix-burst): `"Component '999999999'
  not found. Run: jr component list --project <KEY> to see valid components."` — ZERO snapshot-
  search calls, ZERO `DELETE` calls (the same zero-mutation guarantee BC-8.2.006 Precondition 4
  already establishes for a mismatch, now stated explicitly for a bare 404 too). **[NOTE
  2026-08-15, P4 fix-burst]** This edge case presupposes `jr component delete 999999999` (no
  `--project` supplied, no config) reaches this BC's own disposition-guard logic at all — it
  does, because BC-8.1.004's NUMERIC-ID EXEMPTION means the project-required guard never fires
  for a numeric `NAME|ID` on `delete`, letting control reach this BC's Postcondition 1 check.
**Verification Properties**:
- VP-COMPONENT-003: Neither `--move-to` nor `--orphan` supplied → `DELETE /rest/api/3/
  component/{id}` is never called (`.expect(0)`), regardless of whether the target resolves.
**Trace**: DEC-279; research §Q1.6; ADR-0015

---

#### BC-8.2.002: `--move-to <NAME|ID>` DELETEs with `moveIssuesTo=<targetId>`; target resolution completes BEFORE the DELETE fires

**Confidence**: HIGH
**Source**: research §Q1.1 (CONFIRMED: `moveIssuesTo` reassigns affected issues, does not
delete them, other components on those issues untouched); `src/cli/component.rs` (pending F4)
**Subject**: Component Management — delete safety (DEC-279)
**Behavior**: `--move-to <NAME|ID>` resolves the TARGET component via §8.4 (scoped to the
SAME project as the component being deleted — see BC-8.2.003) BEFORE any `DELETE` call.
**[NEW 2026-08-15, M2 fix-burst — specifies the cross-project-validation mechanism for a
numeric `--move-to` value, closing a gap found by adversarial spec-delta review pass 2]** When
the supplied `--move-to` value is a NAME, §8.4's project-scoped `partial_match` lookup
(BC-8.4.001 step 2) already fetches ONLY the source project's own component list, so a
same-named component in a different project is structurally never considered (BC-8.2.003
EC-8.2.003-1) — no further validation is needed for the name path. When the supplied
`--move-to` value is NUMERIC, `resolve_component`'s bare numeric-bypass short-circuit
(BC-8.4.001 step 1) does NOT by itself confirm which project the id belongs to — a raw
`moveIssuesTo=<targetId>` on the `DELETE` would silently accept an out-of-project id. `jr`
therefore does NOT treat a numeric `--move-to` value as a pure pass-through the way a numeric
`edit`/`delete` positional is (BC-8.1.008's "or is passed straight through" clause does not
apply here): it fires ONE `GET /rest/api/3/component/{targetId}` (the SAME single-resource GET
BC-8.1.008's numeric-bypass path already uses to confirm a numeric source id's existence — not
a full project component-list fetch) to retrieve the target component's `project` field, and
compares it against the source component's own (already-known) project key. This is the
concrete instantiation of BC-8.1.008's general numeric-bypass promise that "the id's existence
is still confirmed by whatever GET/PUT/DELETE call follows" — for `--move-to` specifically,
that confirming call is this one extra `GET`, fired BEFORE the `DELETE`. A mismatch (or a 404
on that GET) is treated identically to "no match in scope" (BC-8.2.004): exit 64, ZERO
`DELETE` calls. Only after the target resolves to exactly one component id AND (for a numeric
target) that id's project is confirmed to match does `jr` issue
`DELETE /rest/api/3/component/{sourceId}?moveIssuesTo=<targetId>`. On 204, affected issues
keep every OTHER component they already had; the deleted component is replaced by the target
component only where it appeared. `--output json` — see BC-8.2.008 for the full canonical
4-key shape (`{"deleted", "movedIssuesTo", "affectedIssueCount", "affectedIssues"}`, N and the
affected-issue-key array both sourced from BC-8.2.007's snapshot **[CORRECTED
2026-08-15, L1 fix-burst — was mis-cited as BC-8.2.006, which owns the confirmation-prompt
behavior, NOT the snapshot itself; the snapshot mechanism is owned entirely by BC-8.2.007]**) —
this BC does not restate the literal to avoid the two copies drifting (see BC-8.2.008's
Idempotency section for the delete-is-not-idempotent taxonomy this shape's `affectedIssues`
array exists to support, per DEC-279).
**[NEW 2026-08-15, M1 fix-burst — pass 3, closes a numeric-SOURCE project-validation gap found
by adversarial spec-delta review pass 3; SCOPE BROADENED 2026-08-15, P4 fix-burst — closes a
silent-orphan gap found by adversarial spec-delta review pass 4]** The `--move-to`-specific
numeric confirmation above establishes the TARGET's project, but until the pass-3 fix-burst
nothing established the SOURCE's project when the `NAME|ID` positional itself is numeric —
`--project A` was accepted at face value with no confirming `GET`, so `jr component delete
20007 --project A --move-to Frontend` where id `20007` actually belongs to project B would
scope `--move-to Frontend`'s resolution to the WRONG project (A) and the eventual cross-project
`DELETE …?moveIssuesTo=<targetId>` would either reach the API as a raw, unhelpful 400 or (worse)
silently resolve `Frontend` against A's own component list, defeating exactly the outcome
BC-8.2.003 exists to prevent. This is closed symmetrically with the target-side mechanism: when
the SOURCE `NAME|ID` is numeric, `jr` fires the SAME single-resource `GET /rest/api/3/component/
{sourceId}` BC-8.1.008's numeric bypass already uses to confirm the id's existence — the
response's `project` field is now ALSO read and becomes the authoritative "known project key"
this BC's own paragraph above relies on when scoping `--move-to` resolution and composing
BC-8.2.001/BC-8.2.006's disposition messages. **This GET's firing is SCOPED to a CHOSEN
disposition, not universal — but as of this fix-burst that means BOTH `--move-to` AND
`--orphan`, not `--move-to` alone.** **Previous version (superseded, retained for audit
trail):** "...it fires only when `--move-to` is the chosen disposition... it does NOT fire
under `--orphan` (which has no `--move-to` target to scope)..." — this left a real gap: under
`--orphan`, the source-confirmation `GET` never fired at all, so `--project A`'s mismatch
against a source id that actually belongs to project B went unchecked and the (irreversible,
no `--move-to` target to sanity-check against) `DELETE` proceeded — `jr component delete
20007 --project A --orphan --yes` would silently orphan issues in project B while the user
believed they were scoping the operation to project A. Nothing about `--orphan` makes a numeric
source's project any less load-bearing to confirm than it is for `--move-to` — if anything, the
irreversibility of `--orphan` (no target component to at least keep the issues attached to)
makes the mismatch MORE consequential to miss, not less, so gating the check on `--move-to`
specifically inverted the risk. **Corrected**: the confirming `GET /rest/api/3/component/
{sourceId}` (already required by BC-8.1.008 for existence, for EVERY numeric source regardless
of disposition) now ALSO has its `project` field read and compared against a supplied
`--project KEY` for BOTH `--move-to` and `--orphan` — i.e. for any path that reaches
BC-8.2.007's snapshot search (mirrors BC-8.2.007 Postcondition 1's "no read-only work before a
disposition is chosen" boundary exactly: the check fires once a disposition is chosen, for
whichever disposition that is). It does NOT fire in the no-disposition exit-64 path (BC-8.2.001
Postcondition 1) — that boundary is unchanged and is not a safety gap: no disposition means no
mutating call of any kind can be reached (BC-8.2.001 Postcondition 1's "zero DELETE calls, zero
snapshot-search calls"), so there is nothing for a project mismatch to silently corrupt in that
path; a numeric SOURCE id's project remains UNCONFIRMED there, same as before this fix-burst
(see BC-8.2.001 Invariant 1's L1-fix-burst note for the consequence: the "not-found reported
before the disposition guard" guarantee still does not extend to a nonexistent numeric source
with no disposition supplied — that is a documented, accepted asymmetry, distinct from the
`--orphan` gap this fix-burst closes, which involved an actual mutating call). If `--project
KEY` was ALSO supplied on the command line and it does NOT match the GET's `project` field, `jr`
exits 64 pre-flight (`"Component <sourceId> belongs to project <actual>, not <KEY>."`) — ZERO
mutating HTTP calls — rather than silently preferring one source of truth over the other; this
mirrors the fail-closed posture BC-8.2.003/EC-8.2.003-2 already applies to a mismatched numeric
`--move-to` target. A non-numeric (name) `NAME|ID` is UNAFFECTED — name resolution (§8.4) is
already inherently scoped to whichever project `--project KEY` (or its config-fallback)
supplies, so there is no analogous ambiguity to close for the name path.
**Config-default-project scope [NEW 2026-08-15, P4 fix-burst]**: this mismatch check compares
the GET's `project` field against an explicitly-supplied `--project KEY` FLAG value ONLY — it
does NOT separately check against a `.jr.toml` configured default project when `--project` is
absent from the command line. This is a deliberate, documented flag-only limitation, not an
oversight: unlike the name-resolution path (where the effective project — flag or config —
actively determines WHICH project's component list is searched, so a wrong effective project
would silently mis-scope the search), the confirming `GET`'s own `project` field is
UNCONDITIONALLY authoritative for scoping `--move-to` resolution regardless of what `--project`
or config says (see the paragraph above) — a config-default mismatch therefore cannot cause
`--move-to` to resolve against the wrong project the way an unchecked flag mismatch could
(there is no flag mismatch case; there's no check to skip a mutation on). The only thing a
config-default check could add is an earlier, friendlier warning for a confused user relying on
`.jr.toml`; that is a UX nicety, not a correctness gap, and is out of scope for this fix-burst.
A future enhancement MAY extend this check to the config-default case for UX parity with the
flag case; until then, a config-default/actual-project mismatch on a numeric source is silently
tolerated (the GET's confirmed project is used regardless, so the command still behaves
correctly — it simply doesn't warn).
**Preconditions**:
1. `--move-to <NAME|ID>` is supplied and `--orphan` is not (clap mutual exclusion, BC-8.2.001).
2. The TARGET `NAME|ID` resolves to exactly one component (§8.4), scoped to the source
   component's project.
3. **[NEW 2026-08-15, M1 fix-burst — pass 3]** When the SOURCE `NAME|ID` is numeric, its
   confirming `GET /rest/api/3/component/{sourceId}` (BC-8.1.008) has resolved the source's
   actual `project` field, and that field — not a bare `--project KEY` flag value — is the
   "known project key" `--move-to` resolution is scoped against; a supplied `--project KEY`
   that mismatches this GET's `project` field exits 64 pre-flight before target resolution
   begins.
**Postconditions**:
1. Target resolution (§8.4) completes successfully BEFORE `DELETE` is called. Ambiguous or
   unknown target → exit 64, ZERO `DELETE` calls (see BC-8.2.004 for the full unknown/
   ambiguous-target contract).
2. `DELETE /rest/api/3/component/{sourceId}?moveIssuesTo=<targetId>` is called exactly once
   on success.
3. **[NEW 2026-08-15, M1 fix-burst — pass 3]** For a numeric SOURCE `NAME|ID`, the confirming
   `GET /rest/api/3/component/{sourceId}`'s `project` field and a supplied `--project KEY` are
   compared; a mismatch exits 64, ZERO mutating HTTP calls (no `--move-to` resolution GET, no
   `DELETE`).
**Edge Cases**:
- EC-8.2.002-1 **[NEW 2026-08-15, M1 fix-burst — pass 3]**: `jr component delete 20007
  --project A --move-to Frontend` where numeric id `20007` actually belongs to project B → the
  source-confirmation `GET /rest/api/3/component/20007` returns `"project": "B"`, which
  mismatches the supplied `--project A` → exit 64 pre-flight, ZERO HTTP beyond the one
  confirming `GET` (no `--move-to` resolution, no `DELETE`).
**Verification Properties**:
- VP-COMPONENT-004: Ambiguous/unknown `--move-to` target → `DELETE` is never called
  (`.expect(0)`) — mirrors BC-2.1.012's "no issue search fired" `.expect(0)` pattern for
  the analogous asset-ambiguity case. **[EXTENDED 2026-08-15, M1 fix-burst — pass 3]** A
  numeric SOURCE `NAME|ID` additionally issues exactly one `GET /rest/api/3/component/
  {sourceId}` (the same confirming GET BC-8.1.008 already requires for existence, now also read
  for its `project` field); a supplied `--project KEY` mismatching that field → `.expect(0)` on
  BOTH the `--move-to` resolution GET and `DELETE` (EC-8.2.002-1). **[SCOPE NOTE 2026-08-15, P4
  fix-burst]** This same confirming `GET`/mismatch check is NOT `--move-to`-exclusive — it now
  also fires under `--orphan` (see BC-8.2.006 Precondition 4/EC-8.2.006-5/VP-COMPONENT-006's
  extension for the `--orphan`-side assertion); this bullet's own wiremock coverage remains
  scoped to the `--move-to` case specifically (EC-8.2.002-1's `--move-to Frontend` fixture).
  **[SCOPE NOTE 2026-08-15, P5 fix-burst]** VP-COMPONENT-004 is, as of this fix-burst, the
  general "numeric-source/target confirming-GET project-confirmation" property shared by FOUR
  caller-side usages, not just `delete`'s two: `delete` SOURCE (this bullet) and TARGET
  (`--move-to`, above), `edit`'s `NAME|ID` (BC-8.1.007 M1, its own VP-COMPONENT-004 bullet), and
  `rename`'s `OLD` (BC-8.3.001 M1, its own VP-COMPONENT-004 bullet) — each command's own BC
  carries its own wiremock-fixture-scoped bullet under this same VP id rather than a duplicate
  property definition.
**Trace**: research §Q1.1; BC-2.1.012 (structural "resolve-before-mutate" precedent); BC-8.1.008
(numeric-bypass confirming GET, now dual-purposed for existence AND project confirmation on the
source side)

---

#### BC-8.2.003: `--move-to` target must resolve within the SAME project as the component being deleted

**Confidence**: HIGH
**Source**: F1 delta analysis §6 Edge-Case Catalog Seed item 8 (flagged gap, closed here);
`src/cli/component.rs` (pending F4)
**Subject**: Component Management — delete safety (DEC-279)
**Behavior**: Because components are project-scoped resources, `--move-to`'s target
resolution (BC-8.2.002) is performed EXCLUSIVELY against the source component's own project's
component list — it never searches other projects, even under a NAME collision. If the
supplied `--move-to` value only matches a component in a DIFFERENT project, that is treated
identically to "no match in scope" (see BC-8.2.004): exit 64, ZERO `DELETE` calls. This
prevents a cross-project move from ever reaching the API layer as an unhelpful raw 400 (or,
worse, an ID collision producing an unintended in-scope match).
**Edge Cases**:
- EC-8.2.003-1: Project A has component "Backend" (id 10001, being deleted); Project B has a
  DIFFERENT component also named "Backend" (id 20007). `--move-to Backend` resolves ONLY
  within Project A's scope — since Project A's OWN "Backend" is the component being deleted,
  this is functionally a self-move (see BC-8.2.005) unless Project A also has a distinct
  second "Backend"-matching entry, which is a name-collision case Jira does not permit within
  one project. Project B's id 20007 is never considered.
- EC-8.2.003-2 **[CORRECTED 2026-08-15, M2 fix-burst — mechanism specified, resolves a
  contradiction found by adversarial spec-delta review pass 2]**: `--move-to 20007` (an
  explicit numeric id belonging to Project B) while deleting a component in Project A → `jr`
  fires `GET /rest/api/3/component/20007` (BC-8.2.002's numeric-target confirmation GET), sees
  `"project": "B"`, compares against Project A → mismatch → exit 64, target not found "in
  project <A>" — ZERO `DELETE` calls. **Previous version (superseded, retained for audit
  trail):** "...the numeric bypass, per BC-8.1.008, still validates the resolved component
  actually belongs to the expected project before accepting it..." — this asserted the
  validation happens without specifying HOW, and BC-8.1.008's OWN numeric-bypass definition
  ("no name-list GET is fired for resolution purposes... passed straight through") has no
  mechanism to perform a project check on its own; BC-8.2.002 now specifies the concrete
  extra `GET` that performs this check, scoped to `--move-to` specifically (BC-8.1.008's
  plain pass-through still applies unchanged to `edit`/`delete`/`rename OLD` numeric targets,
  none of which have a cross-project comparison to make). **[UPDATED 2026-08-15, M1 fix-burst
  — pass 3]** "Project A" in this Edge Case is well-defined regardless of whether the SOURCE
  `NAME|ID` itself is a name or a numeric id: for a name, it is the project `--project KEY` (or
  its config-fallback) scopes name resolution to (unchanged); for a numeric source id, it is
  now the `project` field returned by BC-8.2.002's source-confirmation `GET /rest/api/3/
  component/{sourceId}` (M1 fix-burst, pass 3) — NOT a bare, unconfirmed `--project` flag value.
  The audit-trail sentence above ("BC-8.1.008's plain pass-through still applies unchanged to
  `edit`/`delete`/… numeric targets, none of which have a cross-project comparison to make") is
  now narrower than when written: `delete`'s SOURCE numeric id has since gained exactly one
  cross-project comparison of its own (against a supplied `--project KEY`, BC-8.2.002
  Precondition 3/Postcondition 3). **[FURTHER UPDATED 2026-08-15, P5 fix-burst — resolves
  MED-1/LOW-1 found by adversarial spec-delta review pass 5]** "`edit` and `rename OLD` are
  unaffected and still have none" is now ALSO stale: `edit`'s own `NAME|ID` (BC-8.1.007 M1, new)
  and `rename`'s `OLD` (BC-8.3.001 M1, new) have each since gained the identical cross-project
  comparison — `edit` uses it to derive a project for `--lead` resolution/cache invalidation
  when none is supplied, and to validate a supplied `--project KEY`; `rename` uses it purely to
  validate its REQUIRED `--project KEY` against the numeric `OLD`'s actual project. As of this
  fix-burst, `delete`'s SOURCE, `edit`'s `NAME|ID`, and `rename`'s `OLD` all share this
  mechanism — none of the three numeric-bypass callers remain "unaffected" any longer; only
  `--move-to`'s TARGET-side check (BC-8.2.002's original M1) and these three SOURCE-side checks
  are, together, the complete set of confirming-GET project comparisons in this file.
**Verification Properties**:
- VP-COMPONENT-004 (BC-8.2.002, scope extended by this correction): a numeric `--move-to`
  value additionally issues exactly one `GET /rest/api/3/component/{id}` (BC-8.2.002's
  target-project-confirmation GET) BEFORE the `DELETE`; an out-of-project target (this GET's
  `project` field mismatches the source's project, or the GET itself 404s) → `.expect(0)` on
  `DELETE` — the same zero-DELETE pin VP-COMPONENT-004 already asserts for the ambiguous/
  unknown-target case, now covering the numeric-specific confirmation path too.
**Trace**: F1 delta analysis §6 edge-case item 8; BC-8.2.002 (numeric-target confirmation
mechanism); BC-8.1.008 (the general numeric-bypass convention this BC scopes an exception to)

---

#### BC-8.2.004: `--move-to` target ambiguous or unknown → exit 64 BEFORE the DELETE, listing candidates or valid names

**Confidence**: HIGH
**Source**: §8.4 resolver contracts (BC-8.4.002/003); `src/cli/component.rs` (pending F4)
**Subject**: Component Management — delete safety (DEC-279)
**Behavior**: This BC is the delete-specific instantiation of the shared §8.4 resolver
contracts, applied to the `--move-to` value: zero matches → exit 64 listing valid component
names in the source project's scope (BC-8.4.002); 2+ matches → exit 64 listing the
ambiguous candidates (BC-8.4.003). In both cases, ZERO `DELETE` calls are issued — the
resolver failure is reported and the command exits before any mutating HTTP.
**Trace**: BC-8.4.002; BC-8.4.003; BC-8.2.002 (parent contract)

---

#### BC-8.2.005: `--move-to <SELF>` (target equals the component being deleted) → exit 64 pre-flight, zero HTTP

**Confidence**: HIGH
**Source**: F1 delta analysis §2 (BA-flagged explicit edge case); `src/cli/component.rs`
(pending F4)
**Subject**: Component Management — delete safety (DEC-279)
**Behavior**: After BOTH the source component and the `--move-to` target independently
resolve to a component id (BC-8.1.008, BC-8.2.002 — for a numeric `--move-to` value, this
includes BC-8.2.002's target-project-confirmation `GET`, per the M2 fix-burst mechanism, so
the target's id is already confirmed to belong to the source's project by the time this
comparison runs), `jr` compares the two resolved ids. If they are identical, the command exits
64 with `"--move-to target is the same component being deleted. Choose a different component,
or use --orphan."` — BEFORE the `DELETE` call. This guard fires on ID equality, not
name-string equality, so `--move-to <the-same-name>` and `--move-to <the-same-numeric-id>` are
both caught identically — the mixed name/numeric-id case (EC-8.2.005-2) needs no separate
mechanism because both forms terminate in a plain resolved id before this comparison runs.
**[NOTE 2026-08-15, M1 fix-burst — pass 3, reconciling this BC with the numeric-SOURCE
project-confirmation mechanism]** When the SOURCE `NAME|ID` is ALSO numeric, BC-8.2.002's
source-confirmation `GET`/`--project`-mismatch check (Precondition 3/Postcondition 3) is part
of source resolution and therefore completes BEFORE this BC's self-reference comparison runs —
a `--project`-mismatched numeric source exits 64 on that check, never reaching this one. Once
source resolution has cleared (name path unaffected; numeric path confirmed via the M1
mechanism), this BC's ID-equality comparison is unchanged: EC-8.2.005-1/2 below hold
regardless of whether the source was originally supplied as a name or a numeric id.
**Edge Cases**:
- EC-8.2.005-1: `jr component delete Backend --move-to Backend` (same name given twice) →
  both resolve to the same id → exit 64, zero `DELETE` calls.
- EC-8.2.005-2: `jr component delete Backend --move-to 10001` where `Backend` itself IS id
  `10001` → exit 64 (id-equality catches the mixed name/numeric-id self-reference case too).
**Verification Properties**:
- VP-COMPONENT-005: Resolved source id == resolved target id → `DELETE` is never called
  (`.expect(0)`).
**Trace**: F1 delta analysis §2

---

#### BC-8.2.006: `--orphan` DELETEs with no `moveIssuesTo`; requires `--yes` (non-interactive) or an interactive TTY confirm naming the affected-issue count

**Confidence**: HIGH
**Source**: research §Q1.4 (CONFIRMED: no confirm/force/dry-run parameter exists on the
endpoint itself — `jr` must implement the guard client-side), §Q1.5 (CONFIRMED norm: `gh`/
`acli` prompt-by-default + `--yes` bypass), §Q1.6 recommendation (gate ONLY `--orphan`, not
`--move-to`, behind confirmation — `--move-to` is not destructive to issue data); `src/cli/
component.rs` (pending F4)
**Subject**: Component Management — delete safety (DEC-279)
**Description**: `--orphan` is the strictly MORE destructive of the two dispositions — issues
simply lose the component tag with no replacement, and (per research §Q1.3) the
delete-cascade's own changelog trail is not contractually guaranteed. `jr` therefore requires
an EXPLICIT additional confirmation step for `--orphan` specifically; `--move-to` does not
carry this extra gate (issues keep a component either way under `--move-to`, so the
resolve-before-mutate guards of BC-8.2.002..005 are considered sufficient safety there).
**Preconditions**:
1. `--orphan` is supplied (and `--move-to` is not — clap mutual exclusion, BC-8.2.001).
2. The source `NAME|ID` resolves to exactly one component (BC-8.1.008).
3. The affected-issue snapshot (owned by BC-8.2.007, NOT this BC — see the L1 correction in
   Invariant 2 below) has been taken.
4. **[NEW 2026-08-15, P4 fix-burst — closes a silent-orphan gap found by adversarial spec-delta
   review pass 4]** When the source `NAME|ID` is numeric, BC-8.2.002 M1's source-confirmation
   `GET /rest/api/3/component/{sourceId}` (whose `project`-field mismatch check was broadened by
   this same fix-burst from `--move-to`-only to "any chosen disposition") has resolved and
   passed BEFORE the affected-issue snapshot (Precondition 3) is taken — a supplied `--project
   KEY` that mismatches the confirmed `project` field exits 64 pre-flight (`"Component
   <sourceId> belongs to project <actual>, not <KEY>."`), ZERO snapshot-search calls, ZERO
   `DELETE` calls, and (interactive mode) no confirmation prompt is ever shown. This closes the
   gap where `jr component delete 20007 --project A --orphan --yes` (numeric id `20007`
   actually belonging to project B) would previously proceed straight to the snapshot/prompt/
   `DELETE` using `--project A` at face value, silently orphaning project B's issues while the
   user believed the operation was scoped to project A.
**Postconditions — interactive (stdin is a TTY, `--no-input` absent)**:
1. A `dialoguer` confirm prompt is shown, displaying the component name and the
   affected-issue count from the snapshot: `"Delete component '<name>' and remove it from
   <N> issue(s)? This cannot be undone. [y/N]"`.
2. User declines (or presses Enter for the default `N`) → exit 0 (a declined confirmation is
   not itself an error — mirrors the existing comment-delete confirmation convention), ZERO
   `DELETE` calls.
3. User confirms → proceeds to the `DELETE` call.
**Postconditions — non-interactive (`--no-input` set, OR stdin is not a TTY)**:
1. `--yes` supplied → proceeds directly to the `DELETE` call, no prompt.
2. `--yes` absent → exit 64, `"--orphan requires --yes when running non-interactively. This
   permanently removes the component from <N> issue(s) with no replacement."` — ZERO
   `DELETE` calls.
**Invariants**:
1. `--move-to` NEVER requires `--yes` or an interactive confirm — only `--orphan` carries
   this extra gate (per research §Q1.6's explicit "gate only the irreversible path"
   recommendation, chosen over gating both to avoid friction on the safe path).
2. The affected-issue snapshot (BC-8.2.007's count **[CORRECTED 2026-08-15, L1 fix-burst —
   was mis-cited as "BC-8.2.006's own count"; the snapshot mechanism itself is owned by
   BC-8.2.007, which this BC (BC-8.2.006) and BC-8.2.002 both CONSUME, not originate]**,
   reused by BC-8.2.002's `--move-to` JSON output too) is taken BEFORE the confirmation prompt
   is shown, so the prompt/message
   text always has a real count, never a placeholder. **[UPDATED 2026-08-15, L3 fix-burst —
   pass 3, resolves a firing-boundary ambiguity found by adversarial spec-delta review pass 3]**
   This "taken BEFORE" ordering applies identically to BOTH the interactive prompt (Postconditions
   — interactive item 1) AND the non-interactive `--yes`-absent exit-64 message (Postconditions
   — non-interactive item 2): the snapshot fires BEFORE the `--yes`-required check is evaluated,
   not after. This is why Postconditions — non-interactive item 2's message text can name a real
   `<N>` at all — if the snapshot fired only AFTER the `--yes` check passed, the non-interactive
   `--yes`-absent exit-64 path (which never reaches a passed `--yes` check) would have no count
   available and item 2's message could not include `<N>` as written. The snapshot search itself
   remains READ-ONLY (BC-8.2.007 Postcondition 2), so firing it ahead of the `--yes` check on a
   request that may still exit 64 costs one extra read-only round-trip in that path, not a
   mutation.
**Edge Cases**:
- EC-8.2.006-1: `--orphan --yes` (non-interactive, or TTY with `--yes` supplied anyway) →
  no prompt shown even on a TTY; proceeds directly.
- EC-8.2.006-2: `--orphan` on a component with ZERO affected issues → confirmation prompt/
  message still fires (deleting the component itself is still a permanent action, independent
  of whether any issue currently references it), showing `0 issue(s)`.
- EC-8.2.006-3: `--no-input` + `--orphan` (no `--yes`) → exit 64, same message as plain
  non-interactive without `--yes` — `--no-input` and "stdin is not a TTY" are treated
  identically per the codebase-wide `--no-input` convention.
- EC-8.2.006-4 **[NEW 2026-08-15, L3 fix-burst — pass 3]**: `jr component delete Backend
  --orphan` (non-interactive, `--yes` absent, component affects 7 issues) → exit 64,
  `"--orphan requires --yes when running non-interactively. This permanently removes the
  component from 7 issue(s) with no replacement."` — the snapshot search (BC-8.2.007) fires
  BEFORE this exit-64 check per Invariant 2, so `7` is the real, snapshot-derived count, never
  a placeholder or omitted value.
- EC-8.2.006-5 **[NEW 2026-08-15, P4 fix-burst]**: `jr component delete 20007 --project A
  --orphan --yes` where numeric id `20007` actually belongs to project B → Precondition 4's
  source-confirmation `GET` returns `"project": "B"`, mismatching `--project A` → exit 64
  pre-flight (`"Component 20007 belongs to project B, not A."`), ZERO HTTP beyond the one
  confirming `GET` — no snapshot search, no confirmation prompt, no `DELETE`. Contrast: the
  SAME command with `--project B` (matching) or no `--project` at all proceeds normally.
**Verification Properties**:
- VP-COMPONENT-006: Non-interactive `--orphan` without `--yes` → `DELETE` is never called
  (`.expect(0)`). **[EXTENDED 2026-08-15, L3 fix-burst — pass 3]** The stderr exit-64 message
  contains the real, snapshot-derived affected-issue count `<N>` (not a placeholder, not an
  omitted count) — a wiremock fixture with a non-zero affected-issue count asserts the exact
  `<N>` value appears in the message text, confirming the snapshot search fired before this
  exit-64 check ran (EC-8.2.006-4). **[EXTENDED 2026-08-15, P4 fix-burst]** For a numeric
  source `NAME|ID` under `--orphan`, a `--project KEY` mismatching the source-confirmation
  `GET`'s `project` field (Precondition 4, shared mechanism with BC-8.2.002's VP-COMPONENT-004)
  → `.expect(0)` on the snapshot search AND `DELETE` both — a wiremock fixture asserts zero
  calls to either endpoint (EC-8.2.006-5).
- VP-COMPONENT-007: Interactive decline → `DELETE` is never called (`.expect(0)`); exit 0.
**Trace**: research §Q1.4, §Q1.5, §Q1.6; comment-delete `--yes` convention (DEC-168 family);
BC-8.2.002 M1 (shared numeric-source project-confirmation mechanism, scope broadened by the P4
fix-burst to cover `--orphan`)

---

#### BC-8.2.007: Affected issue keys are snapshotted (JQL `component = <id>`) BEFORE the DELETE, for both `--move-to` and `--orphan`

**Confidence**: HIGH
**Source**: research §Q1.3 (INCONCLUSIVE changelog guarantee → client-side snapshot
recommended as the reconstruction record) and §Q1.6 item 3; `src/cli/component.rs` (pending
F4)
**Subject**: Component Management — delete safety (DEC-279)
**Behavior**: Immediately after the target component resolves (and, for `--move-to`, after
the move-to target also resolves and BC-8.2.005's self-reference check passes) — i.e. once a
disposition has been chosen and cleared every pre-flight guard, and BEFORE the `DELETE` call —
`jr` runs a read-only JQL search `component = <resolvedId>` — the source component's NUMERIC
id, resolved by BC-8.1.008/§8.4, and ONLY the numeric id — capturing the full list of affected
issue keys, NOT merely a count. **[CORRECTED 2026-08-15, M4-p2 fix-burst — resolves an L4
Behavior/Postcondition wording conflict found by adversarial spec-delta review pass 2]** The
search clause carries NO project restriction of its own (no `AND project = <key>`) — component
ids are globally unique across an entire Jira Cloud site (BC-8.2.007 Postcondition 4's own
rationale), so `component = <resolvedId>` alone is already fully and correctly scoped to
exactly the issues carrying that one component, in whatever project it lives in; adding a
redundant `project = <key>` clause would add nothing (an issue matching `component =
<resolvedId>` is, by definition, already in that component's owning project). **Previous
version (superseded, retained for audit trail):** "...scoped to the source component's
project, capturing the full list..." — this phrase suggested the snapshot needed an explicit
project-scoping clause alongside `component = <resolvedId>`, which contradicted this same BC's
own Postcondition 4 ("ALWAYS `component = <resolvedId>`... no project clause" — see the L4
finding this correction resolves). The search RESULT is inherently project-scoped by the
resolved id alone; no `AND project = ...` clause is added or needed.
**[UPDATED 2026-08-15, M1 fix-burst]** This is now NORMATIVE, not optional phrasing: the
snapshot JQL clause MUST use `component = <resolvedId>`, and MUST NOT use
`component = "<name>"`. **Previous version
(superseded, retained for audit trail):** "`component = "<name>"` (or the id-qualified
equivalent)" — presenting the name-based form as an acceptable alternative reintroduces
exactly the cross-project collision BC-8.4.004 exists to prevent: if a DIFFERENT project also
has a component named `<name>` (a legitimate, expected state per BC-8.4.004's own worked
example), a bare `component = "<name>"` JQL clause is NOT itself project-scoped by Jira — it
would match issues in BOTH projects carrying a same-named component, silently inflating the
snapshot (and therefore `affectedIssueCount`) with issues that have nothing to do with the
component actually being deleted. Using the resolved numeric id sidesteps this entirely: ids
are globally unique across projects, so `component = <resolvedId>` can never accidentally
span projects regardless of naming collisions elsewhere in the org. This snapshot serves two
purposes: (a) it supplies the `affectedIssueCount` used in BC-8.2.001's guard message and
BC-8.2.006's confirmation prompt; (b) the full key list is included in `--output json`'s
success payload (see BC-8.2.008), giving the user a reconstructable record independent of
whether Jira's own changelog captures the delete cascade (research §Q1.3 leaves that
unconfirmed).
**Postconditions**:
1. **[CORRECTED 2026-08-15, M3 fix-burst — resolves an ambiguity found by adversarial
   spec-delta review pass 2]** The snapshot search fires exactly once per `component delete`
   invocation that reaches a chosen, guard-cleared disposition — i.e. AFTER BC-8.2.001's
   both-flags-mutual-exclusion guard, and (for `--move-to`) after BC-8.2.002/003/004's target
   resolution and BC-8.2.005's self-reference check all pass — regardless of WHICH disposition
   (`--move-to` or `--orphan`) was ultimately chosen. It does NOT fire in the no-disposition
   exit-64 path (BC-8.2.001 Postcondition 1) or in any pre-flight path that exits 64 before a
   disposition is confirmed (unknown/ambiguous target, self-reference) — there is no value in
   paying for a read-only search on a request that is about to fail regardless of what the
   search would show. **Previous version (superseded, retained for audit trail):** "The
   snapshot search fires exactly once per `component delete` invocation, regardless of
   disposition" — this was read by adversarial review as ambiguous about whether "regardless
   of disposition" meant "including the no-disposition case"; it did not, but the wording
   didn't say so explicitly. Corrected to state the firing condition and its boundary
   unambiguously; see the corresponding correction to BC-8.2.001 Postcondition 1.
2. The snapshot search is READ-ONLY (`POST /rest/api/3/search/jql`) — it never mutates state
   and always fires BEFORE the `DELETE`.
3. If the snapshot search itself fails (5xx/network), the command aborts BEFORE the `DELETE`
   (fail-closed — `jr` will not proceed with an irreversible delete when it cannot confirm
   what will be affected).
4. **[NEW 2026-08-15, M1 fix-burst]** The composed JQL clause is ALWAYS `component =
   <resolvedId>` (numeric id, no quotes) — NEVER `component = "<name>"`. This holds regardless
   of whether the user originally typed a name or a numeric id on the `NAME|ID` positional;
   BC-8.1.008's numeric-bypass/name-resolution both terminate in a resolved numeric id before
   this snapshot fires, and that id is what the snapshot JQL uses. **[UPDATED 2026-08-15, H1
   fix-burst — pass 3]** The composed clause is ALWAYS `component = <resolvedId> ORDER BY key
   ASC` — the trailing `ORDER BY key ASC` is MANDATORY, not optional phrasing, added for the
   same JRACLOUD-95368 pagination-stability reason `search_issue_keys` callers elsewhere in
   this codebase append a stable sort (CLAUDE.md Gotcha, `/search/jql` cursor pagination
   family): this snapshot JQL is composed entirely internally by `jr` (never user-supplied), so
   there is no pre-existing `ORDER BY` to conflict with and no reason to omit the one Jira's own
   pagination-stability guidance calls for.
5. **[NEW 2026-08-15, M1 fix-burst — resolves a pagination gap found by adversarial spec-delta
   review pass 2]** `POST /rest/api/3/search/jql` is cursor-paginated (CLAUDE.md Gotcha,
   `nextPageToken`/JRACLOUD-95368 family). The snapshot MUST iterate ALL pages via the SAME
   `search_issue_keys`-style keys-only pagination loop `jr` already uses elsewhere (e.g.
   `issue list --jql`'s underlying search machinery, `src/api/jira/issues.rs`) before
   composing `affectedIssueCount`/`affectedIssues` — a single-page fetch that silently
   truncates the result set would understate `affectedIssueCount` in BOTH BC-8.2.001's guard
   message and BC-8.2.006's confirmation prompt, and would produce an incomplete
   `affectedIssues` reconstruction record in BC-8.2.008's JSON output, defeating DEC-279's
   reconstruction guarantee. There is NO cap-with-warning fallback for this snapshot — unlike a
   read-only listing command where truncation is an acceptable UX tradeoff, an undercount here
   directly corrupts a safety-critical count the user relies on to decide whether to proceed
   with an irreversible delete, so full pagination is mandatory, not best-effort. A
   snapshot-search page fetch that itself fails mid-pagination is treated identically to
   Postcondition 3 (fail-closed, abort before `DELETE`) — a partial snapshot is never used to
   proceed. **[UPDATED 2026-08-15, H1 fix-burst — pass 3, closes a silent-undercount gap found
   by adversarial spec-delta review pass 3]** "Fails mid-pagination" in the preceding sentence
   is NOT limited to a transport/HTTP error (5xx/network). `search_issue_keys`'s own
   JRACLOUD-95368 anti-loop drift guard (CLAUDE.md Gotcha) does NOT raise an error when it
   aborts pagination early — it sets `has_more=true` on the returned result and hands back
   whatever deduped keys it already collected, which is a SUCCESSFUL Rust return, not an `Err`.
   Because this snapshot's fail-closed rule (as originally worded) was keyed on "the search
   fails," an anti-loop abort — a real, silent partial result — never tripped it, which would
   have let a drift-truncated snapshot proceed to the `--orphan`/`--move-to` confirmation and
   then the `DELETE` with an understated `affectedIssueCount`/`affectedIssues`, corrupting
   exactly the safety-critical count this Postcondition exists to protect on an irreversible
   delete. The fail-closed rule is therefore stated on the LOOP'S OUTCOME, not merely on
   whether an `Err` was returned: if the pagination loop exits for ANY reason other than a
   normal end-of-results completion — including the anti-loop guard's `has_more=true` partial
   return — `jr` treats it identically to a fetch error: abort before `DELETE`, zero `DELETE`
   calls, no confirmation prompt/message is shown using the partial count. Only a loop that
   completes normally (no `nextPageToken` remaining, anti-loop guard never triggered) may be
   used to compose `affectedIssueCount`/`affectedIssues`. **[NEW 2026-08-15, pass-10 fix-burst
   — resolves INFO-1 found by adversarial spec-delta review pass 10]** **[CORRECTED
   2026-08-15, pass-14 fix-burst — resolves an exit-code miscategorization found by
   adversarial spec-delta review pass 14]** Because the
   JRACLOUD-95368 drift-abort sub-path is a SUCCESSFUL Rust return (not an `Err`), `component
   delete`'s own drift-check must synthesize a dedicated error rather than propagate one: on
   detecting `has_more=true` from the snapshot pagination loop, `jr` exits 1 with a NEW,
   purpose-built `JrError` variant (to be added at F4 implementation time — e.g.
   `JrError::SnapshotIncomplete(String)` — falling to the SAME exit-code default (`_ => 1` in
   `src/error.rs::JrError::exit_code()`) already used by `ApiError`/`NetworkError`/`Internal`/
   `Http`/`Io`/`Json`) carrying the text "could not reliably enumerate affected issues —
   aborting delete" (parity with the genuine fetch-error sub-path's exit-1 outcome, but
   distinct from it — this is an application-level synthesized error, not a propagated
   `JrError::ApiError`/`JrError::NetworkError`). **Previous version (superseded, retained for
   audit trail):** "`jr` exits 1 with `JrError::UserError`-shaped text" — this was
   self-contradictory: `JrError::UserError` maps to exit code 64, NOT 1
   (`src/error.rs::JrError::exit_code()`; CLAUDE.md exit-code set), so an implementation built
   literally to that description would exit 64, not the "exits 1" outcome this same sentence
   requires. `JrError::Internal` is likewise UNSUITABLE despite sharing the exit-1 default:
   its doc comment reserves it for "invariant violation / should never happen" bugs (with an
   optional "Internal error:" call-site message prefix), and a JRACLOUD-95368 anti-loop abort
   is an expected, already-documented external data-consistency condition — not a `jr` bug —
   so labeling it Internal would misrepresent the failure to the user.
**Verification Properties**:
- VP-COMPONENT-017: For a chosen, guard-cleared disposition (either `--move-to` or `--orphan`
  — NOT the no-disposition exit-64 path, per Postcondition 1), the read-only JQL snapshot
  (`POST /rest/api/3/search/jql`, `component = <resolvedId> ORDER BY key ASC` — numeric id,
  NEVER `component = "<name>"`, per Postcondition 4) fires exactly once, iterates ALL cursor
  pages to completion before composing the result (Postcondition 5), and strictly before the
  `DELETE`; a snapshot-search failure (5xx/network) — including a failure mid-pagination —
  aborts the command before `DELETE` (`.expect(0)` on DELETE) — fail-closed. Ordering pins are
  the load-bearing part: a mutant that reorders snapshot/DELETE must fail. A wiremock fixture
  with two projects sharing a same-named component (mirrors VP-COMPONENT-010's fixture) MUST
  assert the snapshot JQL body contains the resolved id, not the shared name — a mutant that
  swaps the id for the name string must fail this assertion. A wiremock fixture returning ≥2
  pages via `nextPageToken` MUST assert every page is fetched and
  `affectedIssueCount`/`affectedIssues` reflect the FULL multi-page result, not just the first
  page. **[NEW 2026-08-15, H1 fix-burst — pass 3]** A wiremock fixture that simulates the
  JRACLOUD-95368 anti-loop drift condition (e.g. a `nextPageToken` sequence that never
  terminates, or a page whose returned keys overlap the previous page such that the anti-loop
  guard fires and returns `has_more=true` with a partial deduped key set) MUST assert
  `.expect(0)` on `DELETE` — the drifted, partial snapshot must never be treated as complete
  and must never reach the confirmation prompt or the `DELETE` call. **[EXTENDED 2026-08-15,
  pass-11 fix-burst — resolves LOW-2 found by adversarial spec-delta review pass 11]** The same
  fixture MUST ALSO assert (a) the process exits 1, and (b) the error output contains the
  substring "could not reliably enumerate affected issues — aborting delete" — parity with
  Postcondition 5's synthesized-error contract above; `.expect(0)` on `DELETE` alone does not
  verify the user sees a clear abort signal rather than a silent/misleading success.
**Trace**: research §Q1.3, §Q1.6 item 3; BC-8.4.004 (cross-project collision this
Postcondition 4 correction prevents); CLAUDE.md Gotcha (`/search/jql` cursor pagination,
JRACLOUD-95368 family)

---

#### BC-8.2.008: `--output json` delete result: `{"deleted": "<id>", "movedIssuesTo": "<id>"|null, "affectedIssueCount": N, "affectedIssues": [...]}`; component delete is NOT idempotent — source-not-found → exit 64, concurrent-delete race → exit 1

**Confidence**: HIGH
**Source**: research §Q1.6 item 5 (JSON shape recommendation); research §Q1.6 item 4
(idempotency note, with the "distinguish component-404 from replacement-404" caveat);
`src/cli/component.rs` (pending F4)
**Subject**: Component Management — delete safety (DEC-279)
**Behavior**: On success, `--output json` returns `{"deleted": "<sourceId>", "movedIssuesTo":
"<targetId>" (or `null` under `--orphan`), "affectedIssueCount": N, "affectedIssues":
["<KEY-1>", ...]}` per BC-8.2.007's snapshot. Table mode echoes a one-line confirmation
naming the disposition and count.

**Idempotency**: if the SOURCE `NAME|ID` resolution (BC-8.1.008) itself returns not-found
(the component is already gone), this is the ordinary not-found exit-64 path — NOT treated
as "already deleted, exit 0" — because `jr`'s resolver operates on the project's current
component list, and a genuinely-already-deleted component is indistinguishable from a typo
at the resolver layer; there is no idempotent-retry special case for component delete (unlike
`issue move`'s already-in-target-state idempotency). A `DELETE` call that itself races and
returns 404 (component deleted by a concurrent actor between resolution and the DELETE call)
is surfaced as `ApiError(404)` — exit 1 — distinct from the resolver's exit-64 not-found,
since this is a genuine race rather than a bad user-supplied name.
**Edge Cases**:
- EC-8.2.008-1: `--move-to` target is deleted by a concurrent actor between BC-8.2.002's
  resolution and the `DELETE` call → the `DELETE` itself 404s on the `moveIssuesTo` id →
  `ApiError(404)`, exit 1 (a genuine race, not a resolver-layer not-found).
**Verification Properties**:
- VP-COMPONENT-024 **[NEW 2026-08-15, M10 fix-burst]**: SOURCE `NAME|ID` not found at
  resolution time → exit 64 (`JrError::UserError`, ordinary not-found path, BC-8.1.008), zero
  `DELETE` calls issued — NOT exit 0/idempotent-skip. A `DELETE` call that itself races and
  404s AFTER a successful resolution (source OR `--move-to` target, EC-8.2.008-1) → exit 1
  (`JrError::ApiError(404)`) — the two 404 sources (resolver-layer vs. DELETE-call-layer) are
  DISTINGUISHABLE by exit code (64 vs. 1) and MUST NOT be collapsed into a single "component
  delete is idempotent" behavior; a wiremock fixture pinning both paths in one test asserts
  the exit-code divergence. **[SCOPE NOTE 2026-08-15, P5 fix-burst — resolves LOW-3 found by
  adversarial spec-delta review pass 5]** This is the CANONICAL statement of the resolver-layer-
  404-vs-mutating-call-layer-404 exit-code taxonomy; `edit`'s `PUT` (BC-8.1.007's Idempotency
  section) and `rename`'s `PUT` (BC-8.3.001's Idempotency section) both EXTEND this same
  VP-COMPONENT-024 property to their own mutating call rather than defining a divergent one —
  the taxonomy (resolver/confirming-GET 404 → exit 64; mutating-call 404 after successful
  resolution → exit 1) is now uniform across all three mutating commands' numeric AND name
  paths, closing the asymmetry LOW-3 facet 1 identified.
**Trace**: research §Q1.6 items 4, 5; BC-8.1.007, BC-8.3.001 (P5 fix-burst — this taxonomy
extended to `edit`/`rename`)

---

### 8.3 Component Rename

#### BC-8.3.001: `jr component rename OLD NEW --project KEY` resolves `OLD` scoped to the project, PUTs `{"name": NEW}`

**Confidence**: HIGH
**Source**: F1 delta analysis §4 Wave 4 (thin wrapper over `update_component`, PUT-keeps-id
confirmed); `src/cli/component.rs` (pending F4)
**Subject**: Component Management — rename (issue #608)
**Output channel profile** **[NEW 2026-08-15, M6 fix-burst]**: 4 (Symmetric — stdout for
`--output json` success data, stderr for the table-mode confirmation and any error, per
CLAUDE.md's five output-channel profiles; same profile as BC-8.1.005/BC-8.1.007/BC-8.2.001).
Applies to `jr component rename` as a whole, including the `--all-projects` fan-out
(BC-8.3.002/003) and `--dry-run` (BC-8.3.004) variants — one command, one profile.
**Behavior**: `rename OLD NEW --project KEY` resolves `OLD` via §8.4, scoped to project `KEY`
(no cross-project search — the single-project form NEVER touches another project's
components), then issues `PUT /rest/api/3/component/{id}` with body `{"name": NEW}` (a
degenerate case of the general `component edit --name` PUT — BC-8.1.007 — reused, not
duplicated, at the implementation layer; this BC documents the `rename`-specific CLI surface
and semantics). The component's `id` is unchanged by a rename (PUT-keeps-id, confirmed).

**Numeric-`OLD` project confirmation (M1) [NEW 2026-08-15, P5 fix-burst — resolves LOW-1/LOW-3
found by adversarial spec-delta review pass 5]**: `--project KEY` is unconditionally REQUIRED
on the single-project form of `rename` (Precondition 1 below) — unlike `edit`/`delete`, there is
no config-fallback or numeric-ID exemption from SUPPLYING it (BC-8.1.004 case 3). This does NOT
by itself validate that a numeric `OLD` actually belongs to `KEY`: §8.4's numeric bypass
(BC-8.4.001 step 1) passes a numeric `OLD` straight through with no project check of its own,
so `rename 10042 NewName --project A` where id `10042` actually belongs to project B would
previously PUT against `10042` unconditionally, silently renaming project B's component while
`--project A` was accepted at face value and never checked — the exact LOW-1 gap this fix-burst
closes. `jr` now fires the SAME confirming `GET /rest/api/3/component/{id}` BC-8.1.008's numeric
bypass already requires for existence (and BC-8.1.007 M1/BC-8.2.002 M1 already reuse for
`edit`/`delete`), reads its `project` field, and compares it against the REQUIRED `--project
KEY`. A mismatch exits 64 pre-flight (`"Component <id> belongs to project <actual>, not
<KEY>."`, identical message shape to BC-8.2.002 M1/BC-8.1.007 M1) — ZERO `PUT` calls. If the
confirming `GET` itself 404s, this is the ORDINARY not-found path (BC-8.1.008), exit 64. **[
CORRECTED 2026-08-15, P6 fix-burst — resolves MEDIUM-1 found by adversarial spec-delta review
pass 6]** The message is ALWAYS the PROJECT-QUALIFIED variant here — never the project-less
variant — because `--project KEY` is Precondition 1's unconditional requirement on the
single-project form: `rename` can never reach this confirming `GET` without `--project KEY`
already known, so BC-8.1.008's not-found rule (corrected P6 fix-burst: project-qualified
whenever a project is known by ANY source, including a supplied `--project`, independent of
which call 404s) always resolves to the project-qualified branch for `rename`. **Previous
version (superseded, retained for audit trail; P5 fix-burst):** "...project-less message
variant (BC-8.1.008, corrected P5 fix-burst) — NOT a race" — this was inherited from
BC-8.1.008's then-current (P5) rule, which attributed the project-less variant to any
confirming-`GET`-is-the-404'd-call case regardless of whether `--project` was independently
known; since `rename` always supplies `--project`, that P5 wording could never legitimately
apply to `rename` and, if implemented literally, would have told a user "specify a project"
immediately after they had specified one. NOT a race either way; see the Idempotency section
below. A NAME `OLD` is UNAFFECTED — §8.4's name resolution is already
scoped to `--project KEY` directly, so there is no analogous ambiguity for a numeric `OLD`'s
confirming `GET` to close. This mechanism does NOT apply to `--all-projects` (BC-8.3.002) — that
form has no single `--project KEY` to compare against; its own per-project fan-out resolution
(one `resolve_component` call per discovered project) already scopes each candidate correctly
by construction.

**Preconditions**:
1. `--project KEY` is supplied (single-project form; contrast `--all-projects`, BC-8.3.002).
2. `OLD` resolves to exactly one component within project `KEY` (§8.4).
3. **[NEW 2026-08-15, P5 fix-burst]** When `OLD` is numeric, the confirming `GET
   /rest/api/3/component/{id}` (M1 above) has resolved the component's actual `project` field,
   and that field matches the REQUIRED `--project KEY`; a mismatch exits 64 pre-flight before
   the `PUT` fires.
**Postconditions**:
1. `PUT /rest/api/3/component/{id}` body is exactly `{"name": NEW}` — no other fields are
   touched (this is a pure rename, not a general edit; `--description`/`--lead` are NOT
   available flags on `rename` — use `component edit` for those).
2. On success, `--output json`: `{"renamed": {"id": "<id>", "from": OLD, "to": NEW, "project":
   KEY}}`.
3. **[NEW 2026-08-15, P5 fix-burst]** For a numeric `OLD`, the confirming `GET`'s `project`
   field and the required `--project KEY` are compared; a mismatch exits 64, ZERO `PUT` calls.
**Edge Cases**:
- EC-8.3.001-1 **[NEW 2026-08-15, P5 fix-burst]**: `jr component rename 10042 NewName --project
  A` where numeric id `10042` actually belongs to project B → confirming `GET
  /rest/api/3/component/10042` returns `"project": "B"`, mismatching `--project A` → exit 64
  pre-flight, `"Component 10042 belongs to project B, not A."`, ZERO `PUT` calls. Resolves
  LOW-1.
- EC-8.3.001-2 **[NEW 2026-08-15, P5 fix-burst; CORRECTED 2026-08-15, P6 fix-burst — resolves
  MEDIUM-1 found by adversarial spec-delta review pass 6]**: `jr component rename 999999999
  NewName --project A` (numeric, nonexistent id) → the confirming `GET` 404s → exit 64, ordinary
  not-found path (BC-8.1.008), the PROJECT-QUALIFIED message (`"Component '999999999' not found
  in project A. Run: jr component list"`) — NOT the project-less variant, since `--project A`
  was already known independently of the 404'd `GET` (rename's Precondition 1 guarantees
  `--project` is always supplied); NOT exit 1/`ApiError` either (reserved for a race on the
  follow-up `PUT`; see Idempotency below). **Previous version (superseded, retained for audit
  trail; P5 fix-burst):** "...project-less message — NOT exit 1/`ApiError`..." — the
  project-less attribution was wrong; see M1's correction above for why.

**Idempotency / 404 taxonomy [NEW 2026-08-15, P5 fix-burst — resolves LOW-3 found by
adversarial spec-delta review pass 5]**: `rename`'s `OLD` resolution failing outright — a NAME
matching zero/2+ components (§8.4), or a numeric `OLD` whose confirming `GET` (M1 above) 404s —
is the ORDINARY not-found/ambiguous exit-64 path (BC-8.1.008/BC-8.4.002/BC-8.4.003), never a
race. A `PUT` call that itself races and returns 404 (the component is deleted by a concurrent
actor between a SUCCESSFUL resolution/confirming-`GET` and the `PUT`) is surfaced as
`ApiError(404)` — exit 1 — distinct from the resolver/confirming-`GET`'s exit-64 not-found.
Identical two-tier taxonomy to BC-8.2.008 (`delete`) and BC-8.1.007 (`edit`).

**Verification Properties**:
- VP-COMPONENT-004 **[EXTENDED 2026-08-15, P5 fix-burst]**: this BC's M1 numeric-`OLD`
  project-confirmation mechanism reuses VP-COMPONENT-004's property (originally defined at
  BC-8.2.002 for `delete`, extended to `edit` at BC-8.1.007, extended here to `rename`): a
  supplied `--project KEY` mismatching the confirming `GET`'s `project` field → `.expect(0)` on
  the `PUT` (EC-8.3.001-1).
- VP-COMPONENT-024 **[EXTENDED 2026-08-15, P5 fix-burst]**: see BC-8.2.008's VP-COMPONENT-024
  for the full statement; this BC's `PUT` shares the identical exit-code divergence
  (confirming-`GET`/resolver 404 → exit 64, EC-8.3.001-2; a `PUT` racing to 404 AFTER a
  successful resolution → exit 1).
**Trace**: F1 delta analysis §4; BC-8.1.007 (implementation-layer reuse, PUT partial-update, and
M1 mechanism this BC's own M1 mirrors); BC-8.2.002 M1 (shared numeric-source project-
confirmation mechanism origin); BC-8.2.008 (shared 404 taxonomy this BC's Idempotency section
mirrors)

---

#### BC-8.3.002: `jr component rename OLD NEW --all-projects` fans out: discovers every project containing a component named `OLD` via per-project component-list calls

**Confidence**: HIGH
**Source**: F1 delta analysis §4 Wave 4; F1 delta analysis §6 edge-case item 6 (scale
caveat); `src/cli/component.rs` (pending F4)
**Subject**: Component Management — rename (issue #608)
**Behavior**: `--all-projects` iterates `list_projects` (BC-X.8.005, already paginated) and,
for each accessible project, calls `GET /rest/api/3/project/{key}/components` (BC-8.1.001)
looking for a component whose name case-insensitively EQUALS `OLD` (matching BC-8.3.006's
case-insensitivity — see below). Every project with a matching component gets its own
`PUT /rest/api/3/component/{id}` renaming it to `NEW` (BC-8.3.001's per-project mechanics,
applied N times). This is genuinely O(N) HTTP calls where N = accessible project count (one
list-components GET per project, plus one PUT per matching project) — there is no documented
Jira bulk-rename-across-projects endpoint. This can be slow on a large org; no page/rate-limit
budget beyond `jr`'s existing 429-retry machinery is added by this feature.

**Matching-semantics divergence from §8.4 (INTENTIONAL) [UPDATED 2026-08-15, H4 fix-burst]**:
`--all-projects`'s per-project match is EXACT case-insensitive equality
(`name.to_lowercase() == OLD.to_lowercase()`) — it does NOT run §8.4's `partial_match`
(substring matching + `Ambiguous`/single-substring disambiguation, BC-8.4.001) against each
project's candidate list. This is a DELIBERATE divergence, not an oversight, for two reasons:
(1) **fan-out determinism.** `partial_match`'s substring semantics are inherently
candidate-list-dependent — the SAME input `OLD` could resolve as `Exact` in one project (only
one substring match) and `Ambiguous` in another (two components both containing `OLD` as a
substring), producing an inconsistent, confusing per-project outcome across a single
`--all-projects` invocation; exact-equality has no such dependency — a name either matches or
it doesn't, uniformly, everywhere. (2) **fan-out safety.** `--all-projects` is a
project-spanning bulk-rename operation; loosely matching a SUBSTRING of `OLD` in some projects
would risk renaming components the caller never intended to touch (e.g. `OLD="API"` fuzzily
matching a component named "API Gateway" in a project the caller didn't have in mind) — exact
equality is the conservative, safety-first choice for an operation this broad. §8.4's
`resolve_component`/`partial_match` remains the single-project resolver used by `edit`,
`delete`, `--move-to`, and `rename --project` (the single-project form, BC-8.3.001) — this
divergence is SCOPED to `--all-projects` only.

**Numeric `OLD` under `--all-projects` is REJECTED [NEW 2026-08-15, H4 fix-burst]**: `OLD`
being all-ASCII-digits (BC-8.1.008's numeric-bypass convention) is undefined/meaningless as a
fan-out selector — a numeric component id is inherently single-project-scoped (BC-8.4.001
Invariant 1: id resolution never spans projects), so "find every project with a component
whose id equals N" would either (a) match at most ONE project (ids are globally unique, so a
literal id-equality fan-out degenerates to a single-project rename dressed up as a fan-out) or
(b) be misread by the user as "find every project with a SIMILARLY-NAMED component" when `OLD`
happens to look numeric (e.g. a component genuinely named `"100"`, per the documented
`requesttype fields` numeric-bypass gap, BC-8.1.008 EC-8.1.008-2). Rather than silently picking
one of these two confusing interpretations, `jr component rename OLD NEW --all-projects` with
an all-digit `OLD` exits 64 pre-flight: `"rename --all-projects requires OLD to be a component
NAME, not a numeric id (component ids are project-scoped and cannot be used to select across
multiple projects). Use rename OLD NEW --project KEY to target a single project by id."` — zero
HTTP calls. (A component literally NAMED with all digits, e.g. `"100"`, is therefore also
unreachable by `--all-projects` — the same documented escape-hatch gap as BC-8.1.008
EC-8.1.008-2, now explicitly extended to this fan-out form.)
**Preconditions**:
1. `--all-projects` is supplied (mutually exclusive with `--project`, clap conflict —
   BC-8.3.005).
2. **[NEW 2026-08-15, H4 fix-burst]** `OLD` is NOT all-ASCII-digits — see the "Numeric `OLD`"
   paragraph above. Non-digit `OLD` is the only accepted form under `--all-projects`.
**Postconditions**:
1. Every accessible project is checked exactly once for a component whose name EXACTLY
   case-insensitively equals `OLD` (NOT `partial_match`'s substring semantics — see the
   divergence note above).
2. A project with NO component named `OLD` is silently skipped (not an error) — the fan-out
   is opportunistic, not a strict "every project must have it" requirement.
3. A project WITH a matching component gets exactly one `PUT` renaming it.
**Edge Cases**:
- EC-8.3.002-1 **[AMENDED 2026-08-19, feature-level F5, human-approved]**: Zero projects
  contain a component named `OLD` → exit 64 ("not found"), consistent with the single-project
  form's (BC-8.3.001) "not found" behavior on the same typo/nonexistent-name input. **Previous
  version (superseded, retained for audit trail):** "exit 0 (not an error — the operation ran
  to completion with zero renames performed), summary reports `0 renamed`." That behavior
  diverged from single-project rename, which exits 64 on an unknown `OLD` — a `--all-projects`
  invocation with a typo'd `OLD` silently succeeded with zero renames instead of surfacing the
  mistake. This amendment aligns the fan-out form with the single-project form: a genuinely
  zero-match fan-out is now treated as a resolution failure, not a no-op success. This is
  distinct from Postcondition 2 (a project WITHOUT a matching component is silently skipped
  while at least one OTHER project DOES match — that per-project skip behavior is unchanged;
  only the all-projects-zero-match case changes).
- EC-8.3.002-2 **[NEW 2026-08-15, H4 fix-burst]**: `jr component rename 10042 NewName
  --all-projects` (all-digit `OLD`) → exit 64 pre-flight per Precondition 2, zero HTTP calls
  (no `list_projects`, no per-project component-list GETs). Contrast `jr component rename
  10042 NewName --project FOO` (single-project form) → numeric bypass fires normally per
  BC-8.1.008, unaffected by this guard.
- EC-8.3.002-3 **[NEW 2026-08-15, H4 fix-burst]**: `jr component rename Back NewName
  --all-projects` where Project A has a component named exactly `"Back"` and Project B has a
  component named `"Backend"` (containing `"Back"` as a substring, but not equal to it) →
  Project A's component renames; Project B's is SKIPPED (not ambiguous, not an error) — the
  exact-equality rule means `"Backend"` never matches `OLD="Back"` under `--all-projects`, even
  though `partial_match`'s substring rule (used by the single-project form) might treat `"Back"`
  as an unambiguous or ambiguous partial match of `"Backend"` depending on the rest of that
  project's candidate list.
- EC-8.3.002-4 **[NEW 2026-08-15, P7 fix-burst — resolves LOW-1 found by adversarial spec-delta
  review pass 7]**: `jr component rename 10042 NewName --all-projects --dry-run` (all-digit
  `OLD`, combined with `--dry-run`) → Precondition 2's numeric-`OLD` rejection fires FIRST, exit
  64, ZERO HTTP calls of any kind — no `list_projects`, no per-project component-list GETs, and
  (a fortiori) no `PUT`. This is explicit ordering, not merely an inference from
  EC-8.3.002-2/VP-COMPONENT-026: Precondition 2 is evaluated before BC-8.3.004's `--dry-run`
  project-discovery loop even begins, so `--dry-run` does NOT get a chance to preview a
  "rejected" fan-out — the rejection and the dry-run preview are mutually exclusive outcomes for
  this input, never both. Contrast `jr component rename 10042 NewName --project FOO --dry-run`
  (single-project form) → numeric bypass fires normally per BC-8.1.008, unaffected by this guard,
  and BC-8.3.004's dry-run preview proceeds for that single project. See BC-8.3.004
  EC-8.3.004-2 for the same ordering pinned from the dry-run BC's own perspective.
**Verification Properties**:
- VP-COMPONENT-026: Under `--all-projects`, an all-ASCII-digit `OLD` is rejected exit-64
  pre-flight (`.expect(0)` on `list_projects` AND on every per-project component-list GET —
  zero HTTP of any kind, per Precondition 2/EC-8.3.002-2), and, for non-digit `OLD`, per-project
  matching uses EXACT case-insensitive equality — NOT `partial_match`'s substring semantics
  (BC-8.4.001) — so a candidate containing `OLD` as a substring but not equal to it (e.g.
  `"Backend"` vs. `OLD="Back"`) is silently skipped, not treated as ambiguous or renamed
  (EC-8.3.002-3).
**Trace**: F1 delta analysis §4, §6 item 6 (O(N) scale caveat — documented, not a hard limit);
BC-8.4.001 (§8.4 resolver — the single-project baseline this BC's matching semantics
deliberately diverge from); BC-8.1.008 (numeric-bypass convention, and its EC-8.1.008-2
escape-hatch gap, extended here to the fan-out form)

---

#### BC-8.3.003: `--all-projects` fan-out is per-project atomic: a failure in one project does NOT roll back a successful rename already committed in another

**Confidence**: HIGH
**Source**: F1 delta analysis §2 (BA-flagged; precedent BC-2.7.008 per-file fail-soft
pattern, analogous shape); `src/cli/component.rs` (pending F4)
**Subject**: Component Management — rename (issue #608)
**Behavior**: There is no cross-project transaction — each project's `PUT` either succeeds
or fails independently. A 4xx/5xx renaming the component in project B does NOT undo the
already-committed rename in project A, and does NOT prevent `jr` from attempting project C
next. The command continues attempting every remaining matched project after a per-project
failure (fail-soft, matching the batch-attachment-download precedent's continue-on-error
posture — BC-2.7.008 — applied to a different domain).
**Postconditions**:
1. On completion, `--output json` reports a per-project outcome array:
   `{"renamed": [{"project": "A", "id": "...", "status": "ok"}], "failed": [{"project": "B",
   "error": "<message>"}]}`. Table mode echoes one line per project (`A: renamed`, `B: FAILED
   — <message>`).
2. Exit code: 0 if every attempted project succeeded; 1 if at least one project failed (the
   partial-success case still surfaces as a non-zero exit so scripts notice, even though some
   renames DID land — this is a deliberate divergence from "exit 0 whenever anything
   succeeded," matching the principle that a partially-failed batch operation must not look
   identical to a fully-successful one to an automated caller).
**Edge Cases**:
- EC-8.3.003-1: All matched projects succeed → exit 0, `failed: []`.
- EC-8.3.003-2: 2 of 5 matched projects fail (e.g. one name-collision 400) → the other 3
  still rename; exit 1; JSON `failed` array names both failures with their raw error
  messages.
**Verification Properties**:
- VP-COMPONENT-018: Under `--all-projects`, a per-project `PUT` failure does not roll back an
  already-committed rename in another project and does not stop attempts on remaining matched
  projects (continue-on-error); exit 0 iff every attempted project succeeded, exit 1 if ≥1
  failed; JSON reports `renamed[]` and `failed[]`.
**Trace**: BC-2.7.008 (structural fail-soft-batch precedent, different domain)

---

#### BC-8.3.004: `--dry-run` previews the rename set with ZERO mutating HTTP calls, using the SAME project-discovery logic as the live run

**Confidence**: HIGH
**Source**: BC-3.4.021 (`issue edit --dry-run` `plannedChanges` shape — direct structural
precedent); F1 delta analysis §6 edge-case item 7 (dry-run/live parity requirement);
`src/cli/component.rs` (pending F4)
**Subject**: Component Management — rename (issue #608)
**Behavior**: `--dry-run` (valid with either `--project` or `--all-projects`) performs every
READ-ONLY step of the real run — target resolution (§8.4), and for `--all-projects`, the
FULL per-project discovery loop (BC-8.3.002) — but issues ZERO `PUT` calls. `--output json`
schema: `{"dryRun": true, "targets": [{"project": "A", "id": "10001", "from": OLD, "to":
NEW}, ...]}`. Table mode: `DRY RUN — no changes will be made.` header, then one line per
target project: `  A: <OLD> → <NEW> (id 10001)`.
**Invariants**:
1. The dry-run preview's project-discovery scope is IDENTICAL to what the corresponding live
   run would use — the same `list_projects` filter, the same per-project component-list
   resolution. A dry-run that used a stale or differently-scoped project list than the live
   run would be a correctness bug (F1 delta §6 item 7), not merely a UX nit.
2. Zero `PUT` calls under `--dry-run`, regardless of `--project` or `--all-projects` scope.
**Edge Cases**:
- EC-8.3.004-1: `--dry-run --all-projects` with zero matching projects → `targets: []`,
  exit 0, table shows `0 components would be renamed.`
- EC-8.3.004-2 **[NEW 2026-08-15, P7 fix-burst — resolves LOW-1 found by adversarial spec-delta
  review pass 7]**: `--dry-run --all-projects` with an all-ASCII-digit `OLD` → this BC's
  "FULL per-project discovery loop" behavior does NOT apply — BC-8.3.002 Precondition 2's
  numeric-`OLD` pre-flight rejection (exit 64, zero HTTP) fires BEFORE `--dry-run`'s
  project-discovery loop begins, so there is no `targets` array to preview and no `list_projects`
  call at all. This BC's own "SAME project-discovery logic as the live run" framing (title,
  Invariant 1) is therefore conditioned on `OLD` having already passed BC-8.3.002's numeric-`OLD`
  guard — a numeric `OLD` never reaches this BC's discovery-loop logic in either the live or
  dry-run form. See BC-8.3.002 EC-8.3.002-4 for the same ordering pinned from the rejection
  guard's own perspective.
**Verification Properties**:
- VP-COMPONENT-008: `--dry-run` (either scope) → zero `PUT /rest/api/3/component/{id}` calls
  (`.expect(0)`).
- VP-COMPONENT-026 (cross-reference, EC-8.3.004-2): a numeric `OLD` under `--all-projects
  --dry-run` triggers the SAME `.expect(0)`-on-all-HTTP assertion VP-COMPONENT-026 already pins
  for the live form — `--dry-run` presence does not weaken or bypass the pre-flight guard.
**Trace**: BC-3.4.021; F1 delta analysis §6 item 7; BC-8.3.002 (numeric-`OLD` pre-flight guard
that fires before this BC's discovery loop, P7 fix-burst)

---

#### BC-8.3.005: `rename` without EITHER `--project` OR `--all-projects` → exit 64 (ambiguous scope); `--project` AND `--all-projects` together → exit 2

**Confidence**: HIGH
**Source**: Precedent BC-2.1.006 ("no default scope" philosophy); BC-8.2.001 (the
`--move-to`/`--orphan` split this BC mirrors mechanically); DEC-188 (clap-mechanism exit-code
class — a clap `ArgGroup`/mutual-exclusion rejection is always exit 2, never the app's own
exit 64); `src/cli/component.rs` (pending F4)
**Subject**: Component Management — rename (issue #608)
**Behavior** **[CORRECTED 2026-08-15, H2 fix-burst — resolves a DEC-188 exit-code-class
violation found by adversarial spec-delta review pass 2]**: `--project` and `--all-projects`
are clap `conflicts_with`-paired (mutually exclusive) — supplying BOTH is rejected by clap
itself, exit 2, before any application code runs. Clap has no mechanism that turns a
"neither supplied" state into the app's own exit-64 convention — a bare
`ArgGroup::required(true)` also fails with clap's own exit 2 on the neither-case, which is
exactly the DEC-188 anti-pattern this correction closes. Supplying NEITHER `--project` nor
`--all-projects` is therefore caught by an explicit APPLICATION-LEVEL guard, evaluated
immediately after clap parsing and before any HTTP: `jr` checks `project.is_none() &&
!all_projects` and, if true, returns `JrError::UserError` (exit 64), naming both flags. This
is mechanically IDENTICAL to BC-8.2.001's `--move-to`/`--orphan` split — both-supplied → clap
mutual exclusion → exit 2; neither-supplied → app-level `JrError::UserError` check → exit 64 —
the two BCs share the same two-guard shape; here both `rename` scope selectors are "positive"
choices rather than one being a safety opt-out, but the exit-code mechanics are identical.
**Previous version (superseded, retained for audit trail):** "`--project` and `--all-projects`
form a clap `ArgGroup` requiring exactly one (mirrors the `--move-to`/`--orphan` group on
`delete`, BC-8.2.001, structurally...). Neither supplied → exit 64 before any HTTP, naming
both flags. Both supplied → clap exit 2 (mutual exclusion)." — this attributed the
neither-supplied exit-64 outcome to the `ArgGroup` mechanism itself, which clap cannot produce
(a required-group violation is a clap parse error, exit 2, not `JrError::UserError`'s exit
64). The user-visible OUTCOME (exit 64 naming both flags on the neither-case; exit 2 on the
both-case) is unchanged; only the MECHANISM producing the neither-case outcome is corrected.
**Trace**: BC-2.1.006; BC-8.2.001 (mechanically identical split)

---

#### BC-8.3.006: Case-only rename (`OLD`="Backend", `NEW`="backend") is a legitimate operation — the resolver MUST NOT short-circuit it as a no-op

**Confidence**: HIGH
**Source**: F1 delta analysis §6 edge-case item 2 (validated correction: JQL component-name
matching is case-insensitive at the JQL layer, but a rename that changes ONLY casing is still
a real, valid Jira operation); `src/cli/component.rs` (pending F4)
**Subject**: Component Management — rename (issue #608)
**Behavior**: The §8.4 resolver's case-insensitive `partial_match` lookup (BC-X.10.003) is
used to FIND the component named `OLD` — it must NOT be used to decide whether `OLD` and
`NEW` are "the same" and therefore skip the PUT. `jr component rename Backend backend`
resolves `Backend` (case-insensitively, finding the one component) and then issues
`PUT {"name": "backend"}` exactly as any other rename would — the PUT is NOT skipped merely
because `OLD.to_lowercase() == NEW.to_lowercase()`. This is the corrected premise this issue
is built on: the JQL-layer case-insensitivity does NOT mean the component's OWN stored name
casing is insignificant.
**[EXTENDED 2026-08-15, L6 fix-burst — pass 3, closes a coverage gap found by adversarial
spec-delta review pass 3]** This no-short-circuit rule is stated above in terms of §8.4's
`partial_match` resolver (the single-project path, BC-8.3.001), but the SAME rule applies
identically under `--all-projects` (BC-8.3.002), which does NOT use `partial_match` at all —
it uses its own EXACT case-insensitive equality match (BC-8.3.002's documented divergence).
`jr component rename Backend backend --all-projects` must NOT skip the `PUT` for any matched
project merely because `OLD.to_lowercase() == NEW.to_lowercase()`, for the identical reason:
`--all-projects`'s exact-equality match is used to FIND each project's matching component, not
to decide whether the found component's PUT should be skipped. This is not a separate
mechanism to build — `--all-projects` already issues one `PUT` per matched project
unconditionally (BC-8.3.002 Postcondition 3) — it is a coverage gap in this BC's own scope
statement and VP-COMPONENT-019's fixture, both of which previously named only the single-project
form.
**Edge Cases**:
- EC-8.3.006-1: `rename Backend backend --project FOO` → PUT fires with body `{"name":
  "backend"}`, exit 0, NOT treated as "OLD == NEW, nothing to do."
- EC-8.3.006-2 **[NEW 2026-08-15, L6 fix-burst — pass 3]**: `jr component rename Backend
  backend --all-projects`, where Projects A and B both have a component named exactly
  `"Backend"` → BOTH projects' matching components get a `PUT {"name": "backend"}` (via
  BC-8.3.002's exact-equality fan-out), exit 0, NOT treated as "OLD == NEW, nothing to do" for
  either project.
**Verification Properties**:
- VP-COMPONENT-019: `rename Backend backend` resolves `Backend` case-insensitively and still
  issues `PUT {"name":"backend"}` (`.expect(1)`) — the PUT is NOT skipped merely because
  `OLD.to_lowercase() == NEW.to_lowercase()`. **[EXTENDED 2026-08-15, L6 fix-burst — pass 3]**
  This VP now ALSO pins the `--all-projects` path (EC-8.3.006-2): a wiremock fixture with 2
  projects each having a component named exactly `"Backend"`, invoked as `rename Backend
  backend --all-projects`, MUST assert BOTH projects' `PUT {"name":"backend"}` calls fire
  (`.expect(1)` per project, `.expect(2)` total) — a mutant that special-cases
  `OLD.to_lowercase() == NEW.to_lowercase()` as a skip condition anywhere in the
  `--all-projects` fan-out must fail this assertion identically to the single-project case.
**Trace**: F1 delta analysis §6 item 2; BC-8.3.002 (`--all-projects` exact-equality fan-out this
extension covers)

---

#### BC-8.3.007: `NEW` collides with an existing component name in the same project → Jira 400 surfaced verbatim, NOT pre-validated client-side

**Confidence**: HIGH
**Source**: Precedent BC-X.3.004 (field-specific-error passthrough convention); `src/cli/
component.rs` (pending F4)
**Subject**: Component Management — rename (issue #608)
**Behavior**: `jr` does NOT perform a pre-flight "does `NEW` already exist in this project"
check before issuing the `PUT` — the server already validates name-uniqueness authoritatively
and a client-side pre-check would cost a second round-trip for a case Jira rejects cleanly on
its own. On a 400 name-collision response, the raw Jira error body is surfaced verbatim
(via the existing `extract_error_message` precedence chain, error-taxonomy.md Section 2) —
exit 1 (`ApiError(400, ...)`), same treatment BC-8.1.005/BC-8.1.007's create/edit name
collisions receive.
**Trace**: BC-X.3.004; BC-8.1.005 (create-path symmetry); BC-8.1.007 (edit-path symmetry)

---

### 8.4 Component Name/ID Resolution & Disambiguation

**Placement rationale**: the underlying resolution PRIMITIVE (`partial_match`, project-scoped)
is a pure-function extension of `src/partial_match.rs`, already documented cross-cuttingly at
`cross-cutting.md` BC-X.10.001..003. This subsection owns the COMPONENT-SPECIFIC caller
contracts (numeric-bypass convention, project-scoping rules, disambiguation error-message
shapes) that sit on top of that shared primitive — the same split already established between
`bc-2-issue-read.md`'s status-disambiguation BCs (BC-2.1.013/014, local caller contracts) and
`cross-cutting.md §X.10` (the shared resolver). `BC-X.10.001`'s Edge Cases list gains a new
caller citation for `src/cli/issue/helpers.rs::resolve_component` (see cross-cutting.md
amendment note in this F2 burst).

#### BC-8.4.001: `resolve_component(input, project, candidates)` — all-ASCII-digit input short-circuits to numeric ID; non-digit input resolves via project-scoped `partial_match`

**Confidence**: HIGH
**Source**: CLAUDE.md Gotcha `requesttype fields <NAME|ID>` numeric-bypass (structural
precedent); BC-X.10.001 (underlying `partial_match` behavior); `src/cli/issue/helpers.rs::
resolve_component` (new; pending F4, structural clone of `resolve_team_field`)
**Subject**: Component Management — shared resolver
**Behavior**: Every command accepting a component `NAME|ID` (edit, delete, rename's `OLD`,
`--move-to`, `--lead`'s resolved user is a SEPARATE resolver — not in scope here, see
BC-8.1.006) routes through this shared resolution algorithm: (1) if `input` is entirely
ASCII digits, treat it as a component id directly — no name-list GET is fired for resolution
purposes (though the id's existence is still confirmed by whatever GET/PUT/DELETE call
follows); (2) otherwise, fetch the project's component list (BC-8.1.001's GET, or a warm
cache hit — see the components cache family established at Wave 1) and run
`partial_match(input, &names)` (BC-X.10.001/002/003) to find a matching name.

**Scoped exception [NEW 2026-08-15, M2 fix-burst]**: `--move-to`'s numeric-id case is the ONE
caller of this resolver that does NOT stop at step (1)'s bare pass-through. Because
`--move-to` carries an additional cross-project safety obligation this shared resolver itself
has no way to enforce (BC-8.2.003 — the target must belong to the SAME project as the
component being deleted, and a bare numeric id carries no project information on its own),
BC-8.2.002 layers one extra `GET /rest/api/3/component/{id}` on top of this resolver's numeric
bypass specifically for `--move-to`, to retrieve and compare the target's `project` field
before the `DELETE` fires. **[UPDATED 2026-08-15, M1 fix-burst — pass 3, closes a numeric-
SOURCE gap found by adversarial spec-delta review pass 3]** `delete`'s own SOURCE `NAME|ID` is
now a SECOND caller that does not stop at step (1)'s bare pass-through, for the symmetric
reason: a numeric source id carries no project information either, and `delete --move-to`
needs a "known project key" to scope target resolution against (BC-8.2.002 Precondition 3).
When the SOURCE `NAME|ID` on `delete` is numeric, BC-8.2.002 layers the SAME extra
`GET /rest/api/3/component/{sourceId}` (already required by BC-8.1.008 for existence
confirmation) and additionally reads its `project` field, comparing it against any supplied
`--project KEY`. Every OTHER numeric-bypass caller (`edit`'s own `NAME|ID`, `rename`'s `OLD`)
still has no cross-project comparison to make and is unaffected — this resolver's core
algorithm (steps 1–2 above) is unchanged for all of them; only `delete`'s two caller-side
usages (SOURCE and, when supplied, `--move-to`) add a step the resolver itself does not
perform. **Previous version (superseded, retained for audit trail):** "Every OTHER
numeric-bypass caller (`edit`, `delete`'s own `NAME|ID`, `rename`'s `OLD`) has no cross-project
comparison to make and is unaffected" — this listed `delete`'s own `NAME|ID` among the
unaffected callers, which was accurate before this fix-burst closed the numeric-source gap; it
is `edit`'s `NAME|ID` and `rename`'s `OLD` that remain unaffected now.

**[UPDATED 2026-08-15, P5 fix-burst — pass 5, resolves MED-1/LOW-1 found by adversarial
spec-delta review pass 5]** The claim directly above — "it is `edit`'s `NAME|ID` and `rename`'s
`OLD` that remain unaffected now" — no longer holds. `edit`'s own `NAME|ID` and `rename`'s
`OLD` are now a THIRD and FOURTH caller-side usage that layers the same extra confirming
`GET /rest/api/3/component/{id}` on top of this resolver's bare pass-through: `edit` needs it
to derive a project for `--lead` resolution (BC-8.1.006) and cache invalidation (ADR-0018 §2)
when no `--project`/config is available, and to validate a supplied `--project KEY` against the
id's actual project (BC-8.1.007 M1, new); `rename`'s single-project form always has a REQUIRED
`--project KEY` to validate against (BC-8.3.001 Precondition 1), so its numeric `OLD` uses the
same confirming `GET` purely for that mismatch check (BC-8.3.001 M1, new), symmetric with
`delete`'s own SOURCE usage. As of this fix-burst, ALL FOUR numeric-bypass caller-side usages —
`delete` SOURCE, `delete --move-to` TARGET, `edit`'s `NAME|ID`, and `rename`'s `OLD` — share
this one extra confirming `GET`; the resolver's core algorithm (steps 1–2 above) remains
unchanged in every case — the extra `GET` is caller-side plumbing layered on top, never a
change to `resolve_component` itself.
**Invariants**:
1. `resolve_component` is ALWAYS scoped to exactly one project — it never searches multiple
   projects itself. The caller (edit/delete/rename-single-project) supplies the project
   context; `rename --all-projects` (BC-8.3.002) calls this resolver once PER project it
   iterates, rather than the resolver itself fanning out.
2. Single-substring name matches are `Ambiguous` (never auto-resolved), per BC-X.10.001 —
   this resolver does not override that fail-closed invariant.
**Verification Properties**:
- VP-COMPONENT-014 **[CLARIFIED 2026-08-15, M4 fix-burst]**: `resolve_component(input,
  project, candidates)` is deterministic (same input+candidate list → same `MatchResult`) and
  never panics on arbitrary input; all-ASCII-digit `input` short-circuits to the numeric-id
  path WITHOUT consulting `partial_match` or fetching the candidate list (zero resolver GET
  fired for a numeric id). This is the CANONICAL, sole definition of VP-COMPONENT-014 — BC-8.4.005's
  case-insensitive-agreement claim was previously mis-numbered as a second, divergent
  VP-COMPONENT-014 and has been split out to VP-COMPONENT-021 (see BC-8.4.005's Verification
  Properties for that correction).
**Trace**: BC-X.10.001, BC-X.10.002, BC-X.10.003; CLAUDE.md `requesttype fields` numeric-bypass
Gotcha; BC-8.1.007 M1, BC-8.3.001 M1 (P5 fix-burst — the two additional numeric-bypass callers
that now also derive/confirm a project via this same confirming-GET pattern)

---

#### BC-8.4.002: Unknown component name (zero matches in scope) → exit 64 listing valid component names for the resolved project scope

**Confidence**: HIGH
**Source**: Precedent BC-2.1.014 (`--status NOMATCH` listing pattern); `src/cli/issue/
helpers.rs::resolve_component` (pending F4)
**Subject**: Component Management — shared resolver
**Behavior**: `MatchResult::None` from BC-8.4.001's `partial_match` call constructs:
`"Component '<input>' not found in project <key>. Available: <comma-joined alphabetical
list>."` — mirroring BC-2.1.014's status-NOMATCH shape exactly (alphabetically sorted
available list). Zero mutating (or, for a pure lookup context like `list`, zero
count-enrichment) HTTP calls occur after this error — the failure is reported immediately
after the list-fetch GET that populated the candidate set.
**Trace**: BC-2.1.014

---

#### BC-8.4.003: Ambiguous component name (2+ matches in scope) → exit 64, `Ambiguous component` message listing candidates

**Confidence**: HIGH
**Source**: Precedent BC-2.1.013 (single-substring ambiguity, no search fired); BC-X.10.001;
`src/cli/issue/helpers.rs::resolve_component` (pending F4)
**Subject**: Component Management — shared resolver
**Behavior**: `MatchResult::Ambiguous(matches)` constructs `"Ambiguous component '<input>'.
Matches: <comma-joined candidate names>."` — mirroring BC-2.1.013's shape. As with every
`partial_match`-based caller in this codebase (BC-X.10.001 EC-1), the ambiguity is detected
purely from the already-fetched candidate list — no additional HTTP request is issued beyond
whatever GET populated the candidates.
**Verification Properties**:
- VP-COMPONENT-009: Ambiguous component name on any genuinely-mutating consuming command
  (edit/delete/rename/`--move-to`/`issue edit --component`) issues zero mutating HTTP calls
  (`.expect(0)` on the relevant PUT/POST/DELETE) — the ambiguity fires before any of them.
  **[NARROWED 2026-08-15 issue #605/#606 F2, I-1]** `issue list --component` (a read-only
  path with no mutating HTTP call at all) is out of scope for this VP — its correct pin is
  VP-COMPONENT-013 (`.expect(0)` on the `POST /rest/api/3/search/jql` route, not a
  PUT/POST/DELETE mutation). Previous wording (superseded) listed `issue --component`/`issue
  list --component` in this VP's enumeration, which was vacuous for the list path.
**Trace**: BC-2.1.013; BC-X.10.001; BC-2.1.022 (VP-COMPONENT-013, the read-path pin)

---

#### BC-8.4.004: Component name resolution is ALWAYS single-project-scoped — a same-named component in a different project is NEVER silently considered a match

**Confidence**: HIGH
**Source**: F1 delta analysis §6 edge-case item 1 (headline corrected value of #606/#608);
research context; `src/cli/issue/helpers.rs::resolve_component` (pending F4)
**Subject**: Component Management — shared resolver
**Behavior**: This is the resolver's core cross-project-safety invariant, stated explicitly
because it is the corrected premise the whole #604/#605/#606/#608 bundle depends on (F1 delta
analysis §6 item 1): if Project A and Project B each have a component named "Backend" with
DIFFERENT ids, resolving `--component Backend` (whether on `issue list`, `issue edit`,
`component edit`, or `component delete --move-to`) within a context scoped to Project A's
issues/components ALWAYS resolves to Project A's "Backend" id — Project B's same-named
component is never considered, never causes a false ambiguity, and is never accidentally
selected. This holds even though the underlying `partial_match` primitive itself has no
built-in project-awareness — the project-scoping is enforced entirely by WHICH candidate list
(`Vec<String>` of names) the caller passes in: every consuming call site fetches only its own
project's component list before calling `partial_match`, never a cross-project union.
**Verification Properties**:
- VP-COMPONENT-010: A wiremock fixture with two projects each having a component named
  "Backend" (different ids) — `--component Backend` scoped to Project A resolves to Project
  A's id in every consuming call site (issue edit, issue list filter, component edit,
  component delete --move-to); Project B's component-list endpoint is never called
  (`.expect(0)`) by any of these single-project-scoped operations.
**Trace**: F1 delta analysis §6 item 1

---

#### BC-8.4.005: Client-side resolver case-insensitivity agrees with JQL's case-insensitive component-name matching; `MatchResult::ExactMultiple` disposition is caller-specific (mutating fail-closed, read-path UNION)

**Confidence**: MEDIUM
**Source**: F1 delta analysis §6 edge-case item 2; BC-X.10.003 (`partial_match`
case-insensitive `ExactMultiple` handling); `src/cli/issue/helpers.rs::resolve_component`
(pending F4); F5 adversarial review findings F5-A-M1/F5-C-001 (2026-08-17, human-adjudicated:
UNION)
**Subject**: Component Management — shared resolver
**Behavior**: `partial_match`'s existing case-insensitive exact-match handling
(`name.to_lowercase() == input.to_lowercase()`, BC-X.10.003) means the CLIENT-SIDE resolver
already agrees with JQL's own case-insensitive `component = "..."` matching — a user typing
`--component backend` resolves the same component JQL itself would match for a stored name
`"Backend"`. Two components with names differing ONLY by case within the SAME project (e.g.
"Backend" and "backend" both present) are a degenerate input Jira's own component-creation
validation may or may not permit; this BC does NOT assert whether Jira allows that state to
exist — only that IF it exists, `partial_match` reports `MatchResult::ExactMultiple` (BC-X.10.003
— note the variant itself carries only the FIRST matching name, not the full duplicate id set;
a caller wanting all duplicate ids must re-scan its own already-fetched candidate list by
case-insensitive name).

**[AMENDED 2026-08-17, F5-A-M1/F5-C-001 fix-round — resolves a prior ambiguity in this BC's
own text]** This BC previously stated only that ExactMultiple "treats both as valid exact
matches (no false Ambiguous), consistent with … `--status` resolution, BC-2.1.015" — implying
a SINGLE, universal disposition (auto-resolve-and-proceed) for every caller. That implication
is corrected here: `resolve_component`'s core algorithm (BC-8.4.001) does not itself decide
what to DO with an `ExactMultiple` result — disposition is caller-specific, and the two
caller families genuinely diverge:
- **Mutating callers** (`component edit`; `component delete`'s SOURCE `NAME|ID` and
  `--move-to` TARGET; `rename`'s single-project `OLD`; `issue create --component`; `issue edit
  --component`) FAIL CLOSED on `ExactMultiple`: exit 64, zero mutating HTTP, requiring the
  caller to supply a numeric id to disambiguate which of the duplicate components to actually
  modify, delete, or attach. **[CLARIFIED 2026-08-19, feature-level F5, O-CS-1]** This does NOT
  route through BC-8.4.003's `Ambiguous` message shape — these five mutating command paths
  (`src/cli/component.rs` ×4 call sites covering `edit`/`delete` SOURCE/`--move-to`
  TARGET/`rename`; `src/cli/issue/edit.rs` ×2 call sites for the single-key `issue edit
  --component` path; `src/cli/issue/create.rs` ×1 call site for `issue create --component`)
  emit a DISTINCT, id-listing message instead, pinned here verbatim (`{name}` = the matched
  component name, `{ids}` = comma-joined numeric ids of every candidate sharing that
  case-insensitive name):
  ```
  Multiple components named "{name}" found (IDs: {ids}). Pass the numeric ID directly.
  ```
  This mirrors the established `jr requesttype fields` precedent (`src/cli/requesttype.rs`,
  the byte-identical `"Multiple request types named … Pass the numeric ID directly."` shape) —
  an irreversible or single-target mutation cannot safely guess which duplicate the user meant,
  and the message's own wording steers the caller toward the numeric-bypass escape hatch
  (BC-8.4.001) rather than merely reporting the ambiguity. **Previous version (superseded,
  retained for audit trail):** "BC-8.1.008 branch (0) routes `ExactMultiple` through
  BC-8.4.003's ambiguity handling" — this deferred to BC-8.4.003's `"Ambiguous component
  '<input>'. Matches: <names>."` shape, which is NOT what any mutating call site actually
  emits; the disposition (exit 64, zero mutating HTTP, fail-closed) was and remains correct,
  only the cited message shape was wrong.
- **Read/filter callers** (`issue list --component`, bare/`not:`/`all:` forms) UNION: per
  BC-2.1.018 Postcondition 3, BC-2.1.019 Postcondition 3, and BC-2.1.021 Postcondition 2
  (human-adjudicated 2026-08-17, F5-A-M1/F5-C-001), every id sharing the case-insensitive
  matched name is folded into the composed JQL clause — exit 0, no error, a superset (safe,
  non-lossy) search result. See BC-2.1.022's "ExactMultiple read-path disposition" subsection
  for the full rationale and the contrast with the mutating disposition above.
The `--status` precedent this BC previously cited (BC-2.1.015, "`--status <ExactMultiple>`
treated as Exact") is a DIFFERENT, narrower case that happens to coincide with the "pick one"
outcome only because `status` is single-valued per issue (an issue has exactly one status, so
auto-resolving to either duplicate produces the identical JQL result). `component` is
multi-valued per issue, so "pick one" and "union all" are OBSERVABLY DIFFERENT result sets —
BC-2.1.015's precedent does not, and never did, generalize safely to `--component`; UNION
(not "treat as Exact") is `--component`'s correct generalization of read-path leniency. This
was the root ambiguity F5-A-M1/F5-C-001 flagged: this BC's prior wording did not distinguish
these cases and could be (mis)read as licensing a silent first-pick on the read path, which is
exactly the defect BC-2.1.018/019/021/022 close.
**Confidence rationale**: MEDIUM — the case-insensitive AGREEMENT between the client resolver
and JQL is confirmed by existing code behavior (BC-X.10.003) and is not new; whether Jira
itself permits two same-project components differing only by case is unconfirmed (out of
scope for this BC to assert) and does not change either caller-specific disposition documented
above.
**Verification Properties**:
- VP-COMPONENT-021 **[RENUMBERED 2026-08-15, M4 fix-burst — was erroneously VP-COMPONENT-014,
  duplicating BC-8.4.001's distinct VP-COMPONENT-014 definition]**: The resolver's
  case-insensitive `ExactMultiple` agreement with JQL's case-insensitive component-name
  matching is covered by the same determinism/numeric-bypass proptest+unit suite as
  BC-8.4.001, including the case-only agreement (`Backend`↔`backend`). **Previous ID
  (superseded, retained for audit trail):** this VP was previously numbered VP-COMPONENT-014,
  the SAME id BC-8.4.001 independently assigns to its own, DIFFERENT verification claim
  (resolver determinism + numeric-bypass short-circuit) — a single VP id cannot carry two
  divergent definitions. VP-COMPONENT-014 (BC-8.4.001) is the canonical determinism/
  numeric-bypass claim; this BC's case-insensitive-agreement claim is split out to the new,
  sequentially-next id VP-COMPONENT-021. No behavioral content changed — only the id.
- VP-COMPONENT-022 **[NEW 2026-08-17, F5-A-M1/F5-C-001 fix]**: the read-path UNION disposition
  (see BC-2.1.018/019/021's own Verification Properties sections for the canonical assertion
  text) is cross-referenced here as the counterpart to VP-COMPONENT-009's mutating-path
  fail-closed assertion (BC-8.4.003) — the two VPs together cover both caller-specific
  dispositions for the identical `MatchResult::ExactMultiple` input.
**Trace**: BC-X.10.003; BC-2.1.015 (single-valued-field precedent — cited and DISTINGUISHED,
not equated, as of the 2026-08-17 amendment); BC-8.1.008 branch (0) (mutating fail-closed
disposition); BC-2.1.018 Postcondition 3, BC-2.1.019 Postcondition 3, BC-2.1.021 Postcondition 2
(read-path UNION disposition); BC-2.1.022 (divergence rationale); F1 delta analysis §6 item 2;
F5 adversarial review findings F5-A-M1/F5-C-001 (2026-08-17, human-adjudicated: UNION)

---

## Key Invariants

- Component CRUD/delete/rename are ALWAYS single-project-scoped operations except
  `component rename --all-projects` (BC-8.3.002), the ONE explicit, opt-in exception.
- `component delete` NEVER runs without an explicit `--move-to` OR `--orphan` disposition
  (DEC-279) — no silent default either way.
- `--orphan` is the only disposition requiring `--yes`/interactive confirm; `--move-to` does
  not (BC-8.2.006 Invariant 1).
- Component name resolution NEVER silently spans projects (BC-8.4.004) — this is the
  corrected core value of the #606/#608 bundle.
- `jr component` governs classic Jira project components only, never Atlassian Compass
  components (see file preamble Scope note).

---

## Total BCs in this file: 28 individually-bodied (cumulative 28 incl. range-collapsed; see BC-INDEX.md)
