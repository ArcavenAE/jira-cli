---
document_type: story-decomposition-manifest
phase: phase-f3-incremental-stories
cycle: cycle-003
feature: auth-profile-dx
status: draft
producer: story-writer
created: 2026-09-01
inputs:
  - ".factory/cycles/cycle-003/phase-f1-delta-analysis/delta-analysis.md"
  - ".factory/specs/prd/bc-1-auth-identity.md"
  - ".factory/specs/prd/bc-6-config-cache.md"
  - ".factory/specs/architecture/decisions/ADR-0020-per-profile-credential-ownership-env-tagging-and-oauth-default-at-creation.md"
  - ".factory/cycles/cycle-003/phase-f2-spec-evolution/adr-0011-amendment-staged.md"
  - ".factory/cycles/cycle-003/phase-f2-spec-evolution/architecture-delta.md"
  - ".factory/stories/STORY-INDEX.md"
traces_to: "DEC-312..DEC-328; ADR-0020; ADR-0011 (staged amendment)"
input-hash: "c0cb18a"
---

# F3 Story Decomposition Manifest — `auth-profile-dx` (cycle-003)

**PLANNING PASS ONLY.** This document proposes the story set, BC/VP coverage, and dependency
shape for orchestrator review. No per-story `S-cycle3-*.md` files have been written, and
`STORY-INDEX.md` has not been touched. Story files are the next burst, after this manifest is
approved.

---

## 0. ID Convention (stated, not re-litigated)

`.factory/STATE.md` (Constraints Carried Forward, cycle-003 section) already names the six
cycle-003 stories it anticipates by ID — `S-cycle3-env-tag`, `S-cycle3-percred-storage`,
`S-cycle3-percred-migration`, `S-cycle3-remove-logout-semantics`, `S-cycle3-adr0011-newtype`,
`S-cycle3-oauth-default-creation`, `S-cycle3-chosen-flow-reconcile` — as does the F1 delta
analysis §2. This manifest **continues that convention** (`S-cycle3-<slug>`) rather than the
numeric `S-{issue-number}-<slug>` scheme used elsewhere in `STORY-INDEX.md` (e.g. `S-578-4`,
`S-663-1`), because:

- cycle-003 is an internally-scoped architecture cycle with no originating GitHub issue number
  to anchor a numeric ID to (unlike `S-578-*`/`S-663-1`, which trace to issues #578/#663).
- The `S-cycle3-*` namespace is lexically disjoint from every existing `S-{digits}-*` and
  `S-{ALLCAPS}-*` ID in `STORY-INDEX.md` (161 rows checked) — **zero collision risk**, since no
  existing story ID contains the literal substring `cycle3`.
- STATE.md itself already treats these exact IDs as load-bearing (the F4 obligation note names
  `S-cycle3-adr0011-newtype` by ID as the story that must apply the staged ADR-0011 amendment).
  Renaming now would break that forward reference for no benefit.

One rename from the F1 preliminary list: **`S-cycle3-percred-migration` → `S-cycle3-credential-absence-guard`**
(rationale in §2, story 3). No other F1-listed ID is renamed. `S-cycle3-cache-keychain-version-bump`
(F1 candidate #8) is **dropped entirely**, not renamed (rationale in §3).

No numeric `total_stories` collision is possible from this cycle — `STORY-INDEX.md`'s
`total_stories: 161` counter is a plain count and will simply increment by the number of
stories actually added at the integrate burst.

---

## 1. BC Coverage Matrix

Every BC newly added or amended by cycle-003's F2 pass (bc-1 §1.1/§1.2/§1.4/§1.6, bc-6 §6.1/§6.2),
mapped to exactly one covering story. **24 BCs total (14 new + 10 amended). Full coverage,
zero gaps, zero double-coverage** — verified below.

| BC | Status | Covering Story |
|---|---|---|
| BC-1.1.009 | AMENDED (DEC-315 — per-profile write clause) | `S-cycle3-percred-storage` |
| BC-1.1.010 | AMENDED (DEC-315 — per-profile write clause) | `S-cycle3-percred-storage` |
| BC-1.1.013 | NEW (DEC-313 — interactive OAuth-default picker) | `S-cycle3-oauth-default-creation` |
| BC-1.1.014 | NEW (DEC-313 — non-interactive api-token default) | `S-cycle3-oauth-default-creation` |
| BC-1.1.015 | NEW (DEC-313 — runtime-default-unchanged pin) | `S-cycle3-oauth-default-creation` |
| BC-1.1.016 | NEW (F2-gate hardening — airtight non-interactive guard) | `S-cycle3-oauth-default-creation` |
| BC-1.2.013 | AMENDED (DEC-322/I-3 — non-destructive logout + stderr notice) | `S-cycle3-remove-logout-semantics` |
| BC-1.2.014 | AMENDED (DEC-322/I-4 — 4-step remove, reordered) | `S-cycle3-remove-logout-semantics` |
| BC-1.2.017 | AMENDED (DEC-315 — per-profile write clause) | `S-cycle3-percred-storage` |
| BC-1.2.048 | NEW (DEC-313 — auth_method-is-intrinsic invariant) | `S-cycle3-chosen-flow-reconcile` |
| BC-1.2.049 | NEW (DEC-323 — `--oauth` deprecated-alias) | `S-cycle3-oauth-default-creation` |
| BC-1.2.050 | NEW (DEC-323 — `--api-token` flag) | `S-cycle3-oauth-default-creation` |
| BC-1.2.051 | NEW (DEC-321 — `refresh` override removal) | `S-cycle3-chosen-flow-reconcile` |
| BC-1.4.025 | AMENDED (regression-confirmation clause vs. new sibling migration) | `S-cycle3-credential-absence-guard` |
| BC-1.4.027 | AMENDED (DEC-315 — namespaced-keys split) | `S-cycle3-percred-storage` |
| BC-1.4.029 | AMENDED (cross-ref to `load_api_token` non-inheritance) | `S-cycle3-credential-absence-guard` |
| BC-1.4.031 | NEW (DEC-315 — `store_api_token`/`load_api_token`) | `S-cycle3-percred-storage` |
| BC-1.4.032 | NEW, REDESIGNED (no-copy detect-and-instruct, DEC-326) | `S-cycle3-credential-absence-guard` |
| BC-1.4.033 | NEW, REDESIGNED (partial-write recovery, namespaced-only) | `S-cycle3-credential-absence-guard` |
| BC-1.4.034 | NEW (one-time re-login breaking-change contract) | `S-cycle3-credential-absence-guard` |
| BC-1.6.046 | AMENDED (DEC-324 — `auth list` 5-column ENV break) | `S-cycle3-env-tag` |
| BC-1.6.047 | NEW (DEC-314/324 — `env` JSON/status surfacing) | `S-cycle3-env-tag` |
| BC-6.1.015 | NEW (DEC-314 — `ProfileConfig.env` schema field) | `S-cycle3-env-tag` |
| BC-6.2.015 | AMENDED (DEC-317 — hard-fence `Profile` newtype target contract) | `S-cycle3-adr0011-newtype` |

**Coverage check:** 24/24 BCs assigned to exactly one story. No BC appears twice. No BC has zero
coverage.

### VP Coverage Matrix

| VP | Anchor BC | Covering Story |
|---|---|---|
| VP-AUTHDX-001 | BC-1.1.014 (base + negative-space cells), extended cells declared at BC-1.1.016 | `S-cycle3-oauth-default-creation` |
| VP-AUTHDX-002 | BC-1.1.015 | `S-cycle3-oauth-default-creation` |
| VP-AUTHDX-003 | BC-1.2.048 (specific instance at BC-1.2.051, cited not duplicated) | `S-cycle3-chosen-flow-reconcile` |
| VP-AUTHDX-004 | BC-1.4.031 | `S-cycle3-percred-storage` |
| VP-AUTHDX-005 | BC-1.4.032 | `S-cycle3-credential-absence-guard` |
| VP-AUTHDX-006 | BC-1.4.032 | `S-cycle3-credential-absence-guard` |
| VP-AUTHDX-007 (mandatory keyring-gated scenario) | BC-1.4.032 | `S-cycle3-credential-absence-guard` |
| VP-AUTHDX-008 | BC-1.4.033 | `S-cycle3-credential-absence-guard` |
| VP-AUTHDX-009 | BC-6.1.015 | `S-cycle3-env-tag` |

**Coverage check:** 9/9 VPs assigned. No VP orphaned.

**Note on BC-1.2.051's VP:** VP-AUTHDX-003 is declared once, at BC-1.2.048, and cited (not
re-declared) at BC-1.2.051. Both BCs land in different stories (BC-1.2.048 → `chosen-flow-reconcile`
as the general invariant; BC-1.2.051 → same story, since it is the specific `refresh`-override
removal that invariant governs — see story 7 below, both BCs are in the SAME story, so this is
not actually a cross-story VP split).

---

## 2. Proposed Stories

### Story 1 — `S-cycle3-env-tag`

**Title:** Add `ProfileConfig.env` tag + surface in `auth list`/`auth status`

**BCs covered:** BC-6.1.015 (NEW — schema field), BC-1.6.046 (AMENDED — `auth list` 5th column,
DEC-324 breaking snapshot change), BC-1.6.047 (NEW — JSON/status surfacing, channel-split
verbatim-vs-sanitized)

**VPs upheld:** VP-AUTHDX-009 (tolerant-reader round-trip / deserialization indistinguishability,
property test on `src/config.rs`)

**Proposed `depends_on`:** `[]` — pure-additive schema field, first item in ADR-0020's own
Sequencing (§ Sequencing item 1: "pure-additive, zero dependencies, can land first and
independently").

**Blocks:** none of the other new cycle-003 stories functionally require this to land first
(the `env` field is orthogonal to credential storage), but it is recommended in Wave 1 alongside
`S-cycle3-percred-storage` since both are zero-dependency and file-disjoint (this story touches
`src/config.rs`, `src/cli/auth/list.rs`, `src/cli/auth/status.rs`; percred-storage touches
`src/api/auth.rs`, `src/cli/auth/login.rs`, `src/api/client.rs`).

**Implementation strategy:** tdd (strict). No off-the-shelf library to transfuse — this is a
native serde-field addition plus two CLI display call sites.

**Module criticality:** `src/config.rs` is core (every command path resolves through it) but this
change is additive-only (`Option<String>`, no existing-field mutation) — LOW behavioral risk
despite the module's centrality. `src/cli/auth/list.rs`/`status.rs` are command-handler layer,
MEDIUM criticality (user-facing output, but not on the auth-header hot path). **Note:** no
`module-criticality.md` exists in this repo as of this pass — this is a qualitative assessment
from CLAUDE.md's own module map and the F1/F2 documents, not a lookup against a formal registry.

**Rough story-point estimate:** 5 (small — one schema field, two display call sites, one
insta-snapshot regeneration, one property test).

**Notes:**
- **`auth list` 5-column insta-snapshot break (DEC-324) — MUST be handled in this story.**
  BC-1.6.046 is an explicit, acknowledged breaking change: the pinned 4-column snapshot
  (`NAME, URL, AUTH, STATUS`) becomes 5 columns (`NAME, URL, ENV, AUTH, STATUS`). The
  implementing story's Tasks list MUST include: (a) regenerating
  `src/cli/auth/tests/snapshots/jr__cli__auth__tests__list_table_snapshot.snap` with the new
  column, extending the fixture to include at least one `env`-tagged profile (per BC-1.6.046's
  own note that the 3-profile fixture should be "extended in F4 with at least one `env`-tagged
  profile"), and (b) a CHANGELOG entry under Breaking Changes describing the snapshot/column
  change, per the corpus's existing precedent for BC-1.2.047/S-663-1.
- **Display-sanitization requirement is a shared transform, but this story owns BOTH call
  sites.** BC-1.6.046 EC-1.6.046-2 (table cell) and BC-1.6.047 EC-1.6.047-3 (`auth status` text)
  both require the identical control-character/ANSI-escape-strip + length-cap transform — the
  story should implement this ONCE (a shared helper, mirroring `display_sanitize_filename`'s
  CWE-116 precedent) and apply it at both call sites, not duplicate the logic.
- **Channel-split invariant (do not collapse):** JSON output (`auth list --output json`) must
  stay byte-for-byte verbatim/lossless; only the human/table and human/text channels sanitize.
  This mirrors the `issue edit` description-echo asymmetry (#398) already documented in
  CLAUDE.md — the story's ACs should explicitly test both the verbatim-JSON and the
  sanitized-human paths as separate assertions, not one shared assertion.
- **`Some("")` vs `None` distinction is spec-fixed, not an implementer's choice:** blank cell for
  `Some("")`, `-` placeholder for `None` (EC-1.6.046-1). Do not conflate these two states.

---

### Story 2 — `S-cycle3-percred-storage`

**Title:** Per-profile API-token keychain storage (`store_api_token`/`load_api_token`)

**BCs covered:** BC-1.4.031 (NEW — new per-profile functions), BC-1.4.027 (AMENDED — namespaced-key
split), BC-1.1.009 (AMENDED — `auth login --profile <new>` per-profile write clause),
BC-1.1.010 (AMENDED — `auth login --profile X` vs `JR_PROFILE` per-profile write clause),
BC-1.2.017 (AMENDED — same per-profile write clause, `JR_PROFILE=ghost` scenario)

**VPs upheld:** VP-AUTHDX-004 (round-trip correctness + cross-profile isolation — SECURITY
INVARIANT, property test with bounded generators per O-3, plus a keyring-gated integration test)

**Proposed `depends_on`:** `[]` — ADR-0020 § Sequencing item 2: "no dependencies." This is the
foundational per-profile credential-storage primitive every other credential-touching story in
this cycle builds on.

**Blocks:** `S-cycle3-credential-absence-guard` (needs the reader/writer to exist before it can
guard credential absence), `S-cycle3-remove-logout-semantics` (needs the per-profile pair to
exist as a deletable artifact), `S-cycle3-oauth-default-creation` (needs the storage model in
place before wiring the new creation-time flow to it), transitively `S-cycle3-adr0011-newtype`
and `S-cycle3-chosen-flow-reconcile`.

**Implementation strategy:** tdd (strict). Mirrors `store_oauth_tokens`/`load_oauth_tokens`
byte-for-byte in shape (ADR-0020 § Decision 1) — a same-file, same-pattern addition, not a new
architectural primitive.

**Module criticality:** `src/api/auth.rs` and `src/api/client.rs::load_auth_from_keychain` sit
directly on the auth-header composition hot path (every HTTP call) — **HIGH criticality**, same
class as the existing OAuth-token functions it mirrors. `src/cli/auth/login.rs::login_token` is
command-handler layer touching the same hot path at the write side — HIGH.

**Rough story-point estimate:** 8 (medium — new keychain functions + `client.rs` branch switch +
`login_token` integration + backend-error-vs-absent distinction (I-5) + 3 amended BCs' write-side
clause updates + bounded-generator property test + keyring-gated integration test).

**Notes:**
- **This is the security-sensitive primitive the rest of the cycle depends on** — get the
  backend-error-vs-absent distinction (EC-1.4.031-2) right here, since `S-cycle3-credential-absence-guard`
  builds its entire detect-and-instruct contract on top of this story's error taxonomy.
- **VP-AUTHDX-004's generator is BOUNDED (O-3, F2-gate fix)** — realistic ASCII/email-shaped
  strings only, NOT an unbounded byte-fuzz. Do not widen the generator scope beyond what the BC
  specifies; an unbounded fuzz produces spurious keychain-backend-error failures indistinguishable
  from real defects (macOS Keychain/Windows Credential Manager/Linux Secret Service all impose
  their own content constraints).
- **`oauth_client_id`/`oauth_client_secret` are explicitly OUT of scope** — they remain
  shared/flat (BYO OAuth app credentials, a different axis). Do not touch them in this story.

---

### Story 3 — `S-cycle3-credential-absence-guard` (renamed from F1's `S-cycle3-percred-migration`)

**Title:** No-copy detect-and-instruct guard for absent per-profile API-token credentials

**Rename rationale:** F1's preliminary story #3 was scoped as a "migration" (lazy copy-then-delete
of the shared flat pair, mirroring `load_oauth_tokens`). **That design was REJECTED by explicit
human decision at the F2 gate (DEC-326)** — ADR-0020 § Decision 2 replaces it in full with a
no-copy detect-and-instruct guard: the legacy flat pair is never read as a credential, never
copied, never deleted, for any profile including `"default"`. There is no migration left in this
story's scope, so "migration" in the story name is actively misleading — renamed to
`S-cycle3-credential-absence-guard` to describe what the story actually implements.

**BCs covered:** BC-1.4.032 (NEW, REDESIGNED — no-copy detect-and-instruct, HIGHEST-RISK new
contract in the cycle per F1 §3), BC-1.4.033 (NEW, REDESIGNED — partial-write recovery, narrowed
to namespaced-pair-only), BC-1.4.034 (NEW — one-time re-login breaking-change contract),
BC-1.4.025 (AMENDED — regression-confirmation clause: `load_oauth_tokens` is a MUST-NOT-TOUCH
baseline this story's sibling function must not modify), BC-1.4.029 (AMENDED — cross-reference
confirming `load_api_token`'s non-inheritance mirrors `load_oauth_tokens("sandbox")`'s)

**VPs upheld:** VP-AUTHDX-005 (detect-and-instruct correctness — no legacy pair ever read/copied,
SAFETY-CRITICAL PROPERTY), VP-AUTHDX-006 (no profile special-cased, including `"default"` —
SAFETY INVARIANT), VP-AUTHDX-007 (mandatory keyring-gated end-to-end scenario against the REAL OS
keychain backend — NOT demotable to an ordinary integration test per F1 §3's highest-risk-item
framing), VP-AUTHDX-008 (no-half-credential safety invariant, namespaced-pair case only)

**Proposed `depends_on`:** `["S-cycle3-percred-storage"]` — ADR-0020 § Sequencing item 3: "depends
on #2 (needs the per-profile reader/writer to exist)." `load_api_token`'s detect-and-instruct
branch is layered directly on top of `store_api_token`/`load_api_token`'s namespaced-key-lookup
step from story 2.

**Blocks:** `S-cycle3-remove-logout-semantics`, `S-cycle3-adr0011-newtype`, `S-cycle3-oauth-default-creation`
(all three's Sequencing entries name "#2/#3" as a joint prerequisite).

**Implementation strategy:** tdd (strict). No gene-transfusion candidate — this is bespoke error
taxonomy over an existing keychain primitive.

**Module criticality:** `src/api/auth.rs::load_api_token` — **HIGH criticality, HIGHEST-RISK
story in the cycle** (F1 delta analysis §3 names the shared→per-profile credential-absence
handling as the cycle's HIGH regression-risk item; sits on the auth-header composition hot path
for every HTTP call under `api_token` auth). A defect here means either silent auth failure for
existing users on upgrade (availability) or — pre-F2-gate-redesign — a cross-environment
credential leak (the exact failure mode the no-copy redesign exists to close). Post-redesign the
WORST failure mode (the leak) is removed by construction, but availability risk remains real and
user-facing.

**Rough story-point estimate:** 8 (high complexity despite narrower scope than the original
migration design — 4 dedicated VPs including one MANDATORY keyring-gated scenario against a real
OS backend, 3 amended cross-reference BCs, and a strict "MUST NOT TOUCH `load_oauth_tokens`"
regression discipline that requires a diff-zero check against that function's existing test suite
as a CI gate for this story's PR).

**Notes:**
- **THIS IS THE HIGH-RISK STORY the orchestrator flagged.** Even after the F2-gate redesign
  removed the worst failure mode (cross-environment credential leak via copy), this remains the
  single highest-scrutiny story in the cycle: it is a genuinely new code path on the auth-header
  hot path, it is the one-time breaking change every pre-cycle-003 api-token profile will hit
  (BC-1.4.034), and it carries the cycle's only MANDATORY keyring-gated end-to-end VP
  (VP-AUTHDX-007) — proven against macOS Keychain / Windows Credential Manager / Linux Secret
  Service, not just an in-memory double.
- **Regression discipline is explicit and mandatory, not advisory:** BC-1.4.025's amendment
  states `load_oauth_tokens` and its existing test suite are a MUST-NOT-TOUCH baseline for this
  cycle. The story's Tasks list MUST include running `load_oauth_tokens`'s existing test suite
  byte-for-byte green as a gate on this story's own PR, not merely "existing tests still pass" as
  an incidental side effect.
- **Legacy pair is NEVER auto-deleted, in this story or any other cycle-003 story.** A future
  cleanup command is a recommended follow-up (ADR-0020 § Decision 2) but explicitly out of this
  cycle's scope — do not add legacy-key deletion as scope creep here.
- **CHANGELOG delivery task, elevated:** because BC-1.4.034 is a formal breaking-change contract
  with its own F4 doc-fallout obligation (spec-mandated, not the usual boilerplate), the story's
  CHANGELOG task should be treated as a first-class AC, not a checklist afterthought — the BC
  text itself says "it is not optional polish."

---

### Story 4 — `S-cycle3-remove-logout-semantics`

**Title:** `auth remove` 4-step delete (reordered) + `auth logout` non-destructive notice

**BCs covered:** BC-1.2.013 (AMENDED — non-destructive `logout`, informational stderr notice on
api-token profiles, I-3/SR-015), BC-1.2.014 (AMENDED — 4-step delete with credentials-before-config
reordering, genuine keychain errors surfaced not swallowed, I-4/SR-008)

**VPs upheld:** none dedicated (BC-1.2.014 carries an ordinary F4 test acceptance criterion,
VP-1.2.014-001, for the reordering/error-surfacing behavior — not a promoted VP-AUTHDX property).
`verification_properties:` frontmatter should be `[]` for this story, with the ordinary AC
anchored directly to BC-1.2.014's Postconditions.

**Proposed `depends_on`:** `["S-cycle3-percred-storage", "S-cycle3-credential-absence-guard"]` —
ADR-0020 § Sequencing item 4: "depends on #2/#3." `remove`'s new 4th delete step targets the
per-profile pair story 2 creates; `logout`'s non-destructive contract is defined in explicit
contrast to `remove`'s full-delete contract (BC-1.2.013's Trace cross-references BC-1.4.033's
SR-009 remediation-message fix, which itself depends on story 3's redesigned error taxonomy).

**Blocks:** `S-cycle3-adr0011-newtype` (ADR-0020 § Sequencing item 5 depends on #2/#3/#4 jointly).
**Also blocks `S-cycle3-oauth-default-creation`** — see the cross-story dependency finding below,
which is NOT explicit in ADR-0020's own Sequencing list but is derived from BC text.

**Implementation strategy:** tdd (strict).

**Module criticality:** `src/cli/auth/remove.rs`, `src/cli/auth/logout.rs`, and
`src/api/auth.rs::clear_profile_creds`/`clear_all_credentials` — MEDIUM-HIGH (destructive
operations on credential state; the step-reordering fix (I-4/SR-008) is itself closing a
correctness gap where a partial failure could previously leave a profile in a bad state).

**Rough story-point estimate:** 5 (medium — step reordering + new delete branch + error-surfacing
tightening + informational-notice addition, both changes narrowly scoped to two existing
command handlers).

**Notes:**
- **Derived cross-story dependency (flag for wave-scheduling confirmation, not in ADR-0020's
  own text):** BC-1.1.013 EC-1.1.013-2 (owned by `S-cycle3-oauth-default-creation`) states that
  an interactive/non-interactive mechanism-switch re-declaration in `auth login` "MUST" clear the
  outgoing mechanism's credentials by "reusing the same per-kind clear branches `auth remove`
  uses (`clear_profile_creds`'s OAuth-pair and API-token-pair deletion...)." The
  API-token-pair deletion branch in `clear_profile_creds`/`clear_all_credentials` is added BY
  THIS STORY (BC-1.2.014's 4th step). This means `S-cycle3-oauth-default-creation`'s
  re-declaration credential-clear logic has a real code dependency on this story's output, beyond
  the storage/absence-guard dependencies ADR-0020's Sequencing section states explicitly.
  **Recommend the wave-scheduling step add this edge explicitly** (`S-cycle3-oauth-default-creation`
  depends_on `S-cycle3-remove-logout-semantics`) rather than relying on ADR-0020's item-6 text
  alone, which cites only "#2/#3."
- **Error-surfacing tightening (I-4/SR-008) changes user-facing behavior on a genuine keychain
  backend error** — previously best-effort/swallowed, now aborts and leaves the config entry
  intact for a retry. This is a real behavior change worth a CHANGELOG entry even though it is
  framed as a bugfix, not a breaking change.

---

### Story 5 — `S-cycle3-adr0011-newtype`

**Title:** `Profile(String)` newtype — un-defer ADR-0011, thread through ~60-80 call sites

**BCs covered:** BC-6.2.015 (AMENDED — target contract for the compile-time hard fence,
`cache.rs` + `src/api/auth.rs`'s 4 credential functions + `Config::active_profile_name` +
`JiraClient::profile_name`)

**VPs upheld:** none dedicated — BC-6.2.015's own text frames this as "a pure Rust type-level
change... All risk is mechanical... not behavioral," with the existing cross-profile isolation
tests (BC-6.2.009/BC-6.2.010) as the operative regression safety net, not a new VP.
`verification_properties: []`.

**Proposed `depends_on`:** `["S-cycle3-percred-storage", "S-cycle3-credential-absence-guard", "S-cycle3-remove-logout-semantics"]`
— ADR-0020 § Sequencing item 5, verbatim: "depends on #2/#3/#4 landing first, so the call-site
sweep covers the enlarged, post-restructuring surface exactly once." Both the ADR-0020 amendment
and the staged ADR-0011 amendment are explicit and consistent on this ordering — do not resequence
this story earlier.

**Blocks:** none of the other cycle-003 stories functionally require the newtype to exist first
(BC-1.2.048/BC-1.2.051 in story 7, and BC-1.1.013-016/BC-1.2.049/050 in story 6, are all written
against `profile: &str` signatures and do not name `Profile` as a precondition) — BUT see the
sequencing recommendation below.

**Implementation strategy:** tdd (strict) — though the "test" surface here is overwhelmingly
`cargo build` + the FULL existing regression suite passing unchanged, not new test authorship. No
gene-transfusion candidate (bespoke, mechanical, whole-codebase-scoped Rust refactor).

**Module criticality:** touches `src/cache.rs` (12+ functions), `src/config.rs`
(`Config::active_profile_name`), `src/api/client.rs` (`JiraClient::profile_name`), and
`src/api/auth.rs` (4 credential functions) — the single WIDEST-file-footprint story in the cycle.
Individually each touched function is a straight signature change; in aggregate this is the
largest mechanical diff in the cycle (~60-80 call sites per the corrected F2-gate estimate).
HIGH criticality by footprint, LOW-MEDIUM behavioral risk (compiler-checked, per the ADR's own
framing — a wrong-but-compiling `Profile` substitution is the one residual class not caught by
the type system alone, mitigated by the pre-existing cross-profile isolation tests).

**Rough story-point estimate:** 13 (large — this is the ceiling of the "no story exceeds 13
story points" rule; a ~60-80-call-site mechanical sweep across 4 files is exactly the shape of
diff that risks exceeding a single implementing agent's context budget if under-sized. If the
actual call-site count at implementation time proves materially larger than the ~60-80 estimate,
this story is a strong SPLIT candidate — e.g. a `cache.rs`-only pass plus a separate
`auth.rs`+`Config`+`JiraClient` pass — flagged here for the integrate burst to reassess against
the real diff size once story-writer drafts the full file list.).

**Notes:**
- **This is the F4 story that MUST apply the staged ADR-0011 amendment to
  `docs/adr/0011-type-level-profile-fence.md` as part of its implementation PR.** The staged
  amendment currently lives ONLY at
  `.factory/cycles/cycle-003/phase-f2-spec-evolution/adr-0011-amendment-staged.md` — the
  main-repo file on `develop` still reads Status: Deferred. This is explicitly called out in
  STATE.md's "Constraints Carried Forward" section as the sole outstanding staged-but-unapplied
  F2 item; do not let this story's PR skip the `docs/adr/` file update. The story's Tasks list
  MUST include this as an explicit, named task — not an implicit side effect of "implement the
  newtype."
- **Recommended sequencing (beyond the strict functional dependency above):** although this
  story's ONLY hard functional dependency is stories 2/3/4, ADR-0020's own recommended land order
  places this story (item 5) BEFORE `S-cycle3-oauth-default-creation` (item 6) specifically so
  the call-site sweep captures the "enlarged, post-restructuring surface exactly once." Story 6
  does not itself add new `auth.rs`/`cache.rs` functions, so this ordering is not strictly
  required for correctness, but landing the large mechanical diff BEFORE story 6's feature diff
  avoids a rebase-churn collision on the same files (`src/api/auth.rs`, `src/cli/auth/login.rs`).
  Recommend the wave scheduler honor ADR-0020's literal order here even though the dependency
  graph alone would technically allow story 5 and story 6 to run in parallel.
- **Consequences section explicitly documents a residual:** a correctly-`Profile`-typed but
  semantically-wrong substitution is NOT caught by the type system. Do not oversell this story's
  test coverage as "eliminates cross-profile leakage" — it converts an unenforced convention into
  a compile-time-checked one, while the existing cross-profile isolation tests remain the actual
  proof of correctness for wrong-value substitutions.

---

### Story 6 — `S-cycle3-oauth-default-creation`

**Title:** OAuth-default-at-creation picker + non-interactive guard + `--oauth`/`--api-token` flags

**BCs covered:** BC-1.1.013 (NEW — interactive picker, OAuth default), BC-1.1.014 (NEW —
non-interactive api-token default, regression-safety pin), BC-1.1.015 (NEW — runtime-default
unchanged), BC-1.1.016 (NEW — airtight non-interactive OAuth guard, F2-gate hardening, closes
adversarial finding I-1), BC-1.2.049 (NEW — `--oauth` deprecated-but-accepted alias),
BC-1.2.050 (NEW — `--api-token` explicit flag)

**VPs upheld:** VP-AUTHDX-001 (non-interactive invocation never launches OAuth browser flow —
SAFETY INVARIANT, base case + negative-space cell + 2 extended airtight-guard cells),
VP-AUTHDX-002 (runtime-default-unchanged regression pin)

**Proposed `depends_on`:** `["S-cycle3-percred-storage", "S-cycle3-credential-absence-guard", "S-cycle3-remove-logout-semantics"]`
— ADR-0020 § Sequencing item 6 states "#2/#3" explicitly ("so newly-OAuth-defaulted profiles'
sibling API-token path is already on the new per-profile storage model"); this manifest ADDS
`S-cycle3-remove-logout-semantics` as a derived dependency per the cross-reference finding
documented in story 4's Notes (BC-1.1.013 EC-1.1.013-2's re-declaration credential-clear reuses
`clear_profile_creds`'s API-token-pair branch, which story 4 adds). **Recommend also sequencing
after `S-cycle3-adr0011-newtype` (story 5)** per the file-collision-avoidance rationale in story
5's Notes, even though that is not a hard functional dependency.

**Blocks:** `S-cycle3-chosen-flow-reconcile` (ADR-0020 § Sequencing item 7 depends on #6).

**Implementation strategy:** tdd (strict).

**Module criticality:** `src/cli/auth/login.rs::handle_login` (HIGH — this is the entry point for
every new profile's credential establishment, and the airtight non-interactive guard (BC-1.1.016)
must fire as a precondition BEFORE any network/listener/browser code — a correctness-critical
ordering invariant), `src/cli/auth/refresh.rs::refresh_credentials` (HIGH — extended-cell
non-interactive guard target), `src/cli/mod.rs` (`LoginArgs`/`RefreshArgs` CLI surface — MEDIUM).

**Rough story-point estimate:** 13 (large — 6 BCs including 2 dedicated multi-cell VPs, a
correctness-critical precondition-ordering guard (BC-1.1.016) that must be evaluated before any
network/listener/browser code path is reached in TWO command handlers, plus the interactive
picker default flip and two new/changed CLI flags with mutual-exclusion and deprecation-notice
plumbing. This is the SECOND story at the 13-point ceiling — flag as a split candidate if the
`login.rs`+`refresh.rs`+`mod.rs` diff proves larger than expected once file-level scoping is
done; a natural split point is "creation-time picker + flags" (BC-1.1.013/1.2.049/1.2.050) vs.
"non-interactive guards" (BC-1.1.014/015/016) if needed.).

**Notes:**
- **BC-1.1.016's guard-ordering invariant is the single most safety-critical requirement in this
  story.** ADR-0020 § Decision 8 and architecture-delta §2.3 are explicit: the non-interactive ×
  explicit-`--oauth` / implicit-oauth-profile-`refresh` check MUST be evaluated as a precondition,
  before any network call, callback-listener bind, or browser-open attempt — not a timeout on an
  already-started flow. This is what makes it airtight for CI; get the ordering wrong and a CI
  runner can still hang.
- **The re-declaration credential-clear requirement (EC-1.1.013-2/EC-1.1.014-4, O-1/SR-011) is a
  MUST, not a SHOULD** — when a mechanism-switching re-login clears the outgoing mechanism's
  credentials, this is required behavior, reusing story 4's `clear_profile_creds` branches (see
  the derived dependency above). The companion "emit an informational stderr notice on a
  non-interactive mechanism switch" (EC-1.1.014-4) is explicitly a SHOULD, not a MUST — do not
  over-implement it as a hard requirement, but do not omit it either.
- **Existing-story coordination (not a hard dependency, awareness only):**
  - `S-384` (`is_oauth_auth()` JSM 401-hint gating, status: ready, not yet delivered) consumes
    `auth_method` directly. This story doesn't change the gating logic, but making OAuth the
    default at creation shifts which profiles most commonly hit that gate. No code coordination
    required, but sequence-awareness is worth a mention in the PR description if `S-384` lands
    concurrently.
  - `S-MAINT-532` (draft, global `--profile` fallback coverage gap on Login/Refresh/Logout)
    exercises exactly the `subcmd.profile.or(cli.profile)` composition this story's
    `LoginArgs`/`RefreshArgs` changes touch. F1's delta analysis recommends EITHER landing
    `S-MAINT-532` before this story (clean baseline coverage first) OR folding its scope into
    this story directly. **This manifest recommends folding `S-MAINT-532`'s test additions into
    this story's Tasks list** (adding the missing wiremock-backed `--profile` coverage as part of
    the same PR that touches `LoginArgs`/`RefreshArgs`) rather than landing it as a fully separate
    story, since the two would otherwise touch the identical composition logic in back-to-back
    PRs — orchestrator/human should confirm this folding decision before F4 dispatch.
  - `S-663-1` (`auth switch --profile` guard, DONE/shipped) touches `main.rs`'s
    `AuthCommand::Switch` arm only — this story touches `Login`/`Refresh` arms, a structurally
    disjoint dispatch path. No coordination needed; confirmed no interaction.

---

### Story 7 — `S-cycle3-chosen-flow-reconcile`

**Title:** Remove `chosen_flow_for_profile`'s per-command override; `auth_method` fully intrinsic

**BCs covered:** BC-1.2.048 (NEW — general `auth_method`-is-intrinsic invariant), BC-1.2.051
(NEW — specific `auth refresh --oauth`/`--api-token` override removal, "relogin-then-replace"
ordering fix I-6)

**VPs upheld:** VP-AUTHDX-003 (`auth_method`-is-intrinsic invariant: no per-command mechanism
override — SAFETY INVARIANT, 2×3 mechanism/flag proptest matrix)

**Proposed `depends_on`:** `["S-cycle3-oauth-default-creation"]` — ADR-0020 § Sequencing item 7,
verbatim.

**Blocks:** none.

**Implementation strategy:** tdd (strict).

**Module criticality:** `src/cli/auth/refresh.rs::refresh_credentials` (HIGH — this is now the
SOLE citable F6 target per the F2-gate SR-013 correction; `chosen_flow_for_profile` is REMOVED
entirely, not merely simplified). `src/cli/auth/mod.rs::chosen_flow_for_profile` (removal
target).

**Rough story-point estimate:** 5 (medium — a removal + a reorder-sensitive correctness fix
(I-6's "relogin-then-replace, never clear-then-fetch" ordering) + a 2×3 proptest matrix).

**Notes:**
- **I-6's ordering invariant is a genuine correctness fix, not just a rename.** The prior
  "clear-then-relogin" framing was self-contradicting (BC-1.2.051's Trace notes this was caught
  by adversary pass-2, L-1): a `refresh` that fails to obtain a usable replacement credential
  MUST leave the existing credential pair completely intact. Implement via option (a) from
  BC-1.2.051's Invariant 2 — obtain/confirm the new value first, then `store_api_token` overwrites
  atomically-in-effect — never a separate delete-then-fetch step.
- **This is a breaking change already acknowledged in ADR-0020** (a script relying on
  `jr auth refresh --oauth` to force an OAuth relogin on an `api_token` profile will see the flag
  silently narrow to a no-op on mechanism selection, not error) — the story's CHANGELOG task
  should cite this explicitly, mirroring the corpus's precedent for BC-1.2.047/S-663-1.
- **`SR-013` F6-target correction is binding:** cite `refresh.rs::refresh_credentials` only for
  VP-AUTHDX-003's F6 target — do NOT cite `chosen_flow_for_profile`, since it will not exist
  post-implementation.

---

## 3. Dropped F1 Candidate

**`S-cycle3-cache-keychain-version-bump`** (F1 §2 item 8, CONDITIONAL on Open Question 1) is
**dropped, not deferred or renamed.** ADR-0020 § Decision 3 and BC-6.2.004's cycle-003
confirmation (DEC-325a) both resolve F1's Open Question 1 definitively: no keychain version
marker is introduced (unproven, non-disposable-data infrastructure with no existing lever, per
§ Alternatives Considered), and the cache-root `v1/` segment is explicitly
**DOCUMENTED-UNCHANGED this cycle** — "cycle-003's new per-profile keychain layout... does not
introduce an analogous keychain-namespace version marker." There is no remaining code change for
a story to implement. No BC targets this story. If a future cycle later decides a cache-root bump
is worthwhile, it reuses the existing `v1/` lever and is a new, independent story at that time —
not a resurrection of this one.

## 4. Interleaved (Not Standalone) F1 Candidates

Per F1 §2's own framing, two candidates are explicitly NOT standalone stories:

- **`S-cycle3-docs`** (F1 item 9): doc updates (`docs/specs/multi-profile-auth.md`, CLAUDE.md
  doc-fallout, the `docs/adr/` ADR-0011 file application) land in the SAME PR as their triggering
  code change, per the repo's doc-fallout convention — not a single end-of-cycle doc story. The
  one EXCEPTION already called out per-story above: `S-cycle3-adr0011-newtype` (story 5) owns the
  `docs/adr/0011-type-level-profile-fence.md` application as a named task in its own PR — this is
  not "docs interleaved," it is a specific, binding F4 obligation for that one story.
- **`S-cycle3-regression-coverage`** (F1 item 10): new/extended test files (api-token-migration
  test parity with `tests/migration_legacy.rs`'s pattern, keyring-gated round-trip tests,
  `tests/auth_profiles.rs` extensions for `env`/per-profile credentials) are scoped per-story
  above, not as one terminal story — each story's own VP/AC list already names its required test
  shapes.

---

## 5. Lead Sequence — F1's Recommendation vs. This Manifest

F1 §2 suggested a lead sequence: **env-tag → per-profile credential storage → no-copy
detect-and-instruct → ADR-0011 newtype.**

**This manifest CONCURS with F1's lead sequence, refined by ADR-0020's own § Sequencing section**
(the authoritative, F2-gate-settled ordering, which supersedes F1's necessarily-provisional
guess):

1. `S-cycle3-env-tag` (parallel with #2, no deps)
2. `S-cycle3-percred-storage` (parallel with #1, no deps)
3. `S-cycle3-credential-absence-guard` (depends #2)
4. `S-cycle3-remove-logout-semantics` (depends #2, #3)
5. `S-cycle3-adr0011-newtype` (depends #2, #3, #4)
6. `S-cycle3-oauth-default-creation` (depends #2, #3, #4 per ADR-0020; this manifest ADDS #4 as a
   derived dependency beyond ADR-0020's literal "#2/#3" text — see story 4/6 Notes; recommended,
   not required, to also land after #5)
7. `S-cycle3-chosen-flow-reconcile` (depends #6)

The one refinement beyond F1's four-item summary: F1's sequence collapsed "per-profile credential
storage" and "no-copy detect-and-instruct" as items 2/3 already (matching this manifest 1:1), but
did not surface the `S-cycle3-remove-logout-semantics` → `S-cycle3-oauth-default-creation`
cross-dependency this manifest's BC-level reading found (§ story 4/6 Notes) — flagged explicitly
for the wave-scheduling step to encode.

## 6. Preliminary Wave Grouping (rough — full schedule at the integrate burst)

> **Superseded pointer:** this section's 6-wave grouping is preliminary only. The
> AUTHORITATIVE schedule is the 5-wave Kahn layering in `wave-schedule.md` §2–3, which
> merges `S-cycle3-adr0011-newtype` and `S-cycle3-oauth-default-creation` into one
> parallel Wave 4 (with a recommended intra-wave delivery order, not a dependency edge).

| Wave | Stories | Rationale |
|---|---|---|
| Wave 1 | `S-cycle3-env-tag`, `S-cycle3-percred-storage` | Both `depends_on: []`; file-disjoint (`config.rs`+`cli/auth/{list,status}.rs` vs. `api/auth.rs`+`cli/auth/login.rs`+`api/client.rs`) — genuinely parallelizable. |
| Wave 2 | `S-cycle3-credential-absence-guard` | Depends on Wave 1's `percred-storage`; HIGH-risk story, recommend NOT parallelizing with anything else in its wave so review attention is undivided. |
| Wave 3 | `S-cycle3-remove-logout-semantics` | Depends on Waves 1-2. |
| Wave 4 | `S-cycle3-adr0011-newtype` | Depends on Waves 1-3; large mechanical diff, recommend landing alone (no wave-mate) to avoid merge-conflict churn against any other in-flight story touching `auth.rs`/`cache.rs`. |
| Wave 5 | `S-cycle3-oauth-default-creation` | Depends on Waves 1-4 (including the derived dependency on Wave 3's `remove-logout-semantics`, and the recommended-not-required sequencing after Wave 4's newtype sweep). |
| Wave 6 | `S-cycle3-chosen-flow-reconcile` | Depends on Wave 5. |

This is a 6-wave, fully-serialized-after-Wave-1 schedule — the credential-storage/absence/remove/
newtype chain is inherently linear per ADR-0020's own Sequencing section; only Wave 1 offers real
parallelism. The wave-scheduling skill (DF-022) should re-derive this formally once story files
carry exact `depends_on`/`blocks` frontmatter, but this rough grouping should not change in shape
unless the derived `remove-logout-semantics` → `oauth-default-creation` edge (§5) is rejected on
review.

---

## 7. Summary

- **7 stories proposed:** `S-cycle3-env-tag`, `S-cycle3-percred-storage`,
  `S-cycle3-credential-absence-guard`, `S-cycle3-remove-logout-semantics`,
  `S-cycle3-adr0011-newtype`, `S-cycle3-oauth-default-creation`, `S-cycle3-chosen-flow-reconcile`.
- **1 F1 candidate dropped** (`S-cycle3-cache-keychain-version-bump` — resolved as a documented
  no-op by ADR-0020 §3/DEC-325a, no code change remains).
- **2 F1 candidates confirmed interleaved, not standalone** (`S-cycle3-docs`,
  `S-cycle3-regression-coverage`) — except the ADR-0011 file application, which is a named,
  binding task inside `S-cycle3-adr0011-newtype`.
- **24/24 BCs covered, exactly once each** — no gaps, no duplicates (§1).
- **9/9 VPs covered, exactly once each** — no gaps, no duplicates (§1).
- **One cross-story dependency finding beyond ADR-0020's literal Sequencing text**: `S-cycle3-oauth-default-creation`
  should additionally depend on `S-cycle3-remove-logout-semantics` (derived from BC-1.1.013
  EC-1.1.013-2's reuse of `clear_profile_creds`'s per-kind clear branches) — flagged for
  orchestrator/wave-scheduler confirmation, not silently assumed.
- **One folding recommendation flagged for human/orchestrator decision**: `S-MAINT-532`'s test
  scope into `S-cycle3-oauth-default-creation`, rather than as a fully separate pre-existing
  draft story landing concurrently against the same composition logic.
- **Total rough story points across the 7 stories: ~57** (5+8+8+5+13+13+5).
- **No conflict found with in-progress/done work**: `S-663-1` (done) touches a structurally
  disjoint dispatch arm; `S-384` (ready, undelivered) is sequence-aware-only, no code overlap.
