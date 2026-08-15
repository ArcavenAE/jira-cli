# Verification Delta — Component Management bundle (F2)

**Date:** 2026-08-15 (refreshed — supersedes the prior revision flagged STALE by adversarial
spec-delta review pass 1, finding H3; further updated same-day, spec-tightening burst, to close
residuals R-1/R-2/R-3 by minting VP-COMPONENT-025/026 and cross-referencing BC-8.1.008 — see §7;
further updated same-day, pass-3 fix-burst, extending VP-COMPONENT-004/006/012/017/019 in place
— no new VPs minted, run stays 001..026 — see §8; further updated same-day, pass-4 fix-burst,
extending VP-COMPONENT-002/004/006 in place — no new VPs minted — see §9; further updated
same-day, pass-5 fix-burst, extending VP-COMPONENT-004/024 in place to cover `edit`/`rename`
numeric-bypass project confirmation and 404 taxonomy — no new VPs minted, run stays 001..026 —
see §10; further updated same-day, pass-6 fix-burst, re-syncing §3's BC↔VP mapping table with
already-minted VP-004/024 extensions — no new VPs minted, run stays 001..026 — see §11; further
updated same-day, pass-7 fix-burst, minting VP-COMPONENT-027/028 to close BC-3.4.020/021's
under-pinned `--component` amendments and citing the pre-existing base VP-396-005 for
BC-3.4.017 — run extends to a complete, gapless, collision-free `001..028` — see §12; further
updated same-day, pass-10 fix-burst, correcting VP-COMPONENT-012 §1.2/§5's live-smoke gate
wording from "1×ADD, 1×REMOVE, 1×REPLACE" to "1×ADD, 1×REMOVE" (`jr` never emits a REPLACE
`bulkEditMultiSelectFieldOption` — no `set:`/`replace:` CLI grammar exists) — no new VPs minted,
run stays 001..028; further updated same-day, pass-11 fix-burst, extending VP-COMPONENT-017's
anti-loop-drift fixture (both here and in BC-8.2.007's own inline VP-017 subsection) to assert
exit code 1 and the synthesized-error message substring, parity with BC-8.2.007 Postcondition
5's pass-10 synthesized-error contract — no new VPs minted, run stays 001..028; further updated
same-day, pass-16 fix-burst, extending VP-COMPONENT-023's Property/Method text in place to
require `.expect(0)` on BOTH the §8.4 resolution `GET` and the numeric-source confirming `GET`
for the no-fields case (not merely the `PUT`), resolving BC-8.1.007's precondition-ordering
contradiction for a NAME input — no new VPs minted, run stays 001..028)
**Phase:** F2 (Feature Mode) — verification-property formalization, SPEC-time only (no test/proof code; that is F3/F4/F6)
**Scope:** issues #604 (`jr component list/create/edit/delete`), #605 (`issue create/edit --component`), #606 (`issue list --component`), #608 (`jr component rename`)
**Inputs read (current BC bodies, this refresh):** `bc-8-components.md` (28 BCs, all §8.1–8.4),
`bc-2-issue-read.md` (BC-2.1.007/018-022, BC-2.3.040), `bc-3-issue-write.md`
(BC-3.4.012/013/017/022-025), `cross-cutting.md` (BC-X.10.001),
`.factory/research/component-delete-and-bulk-wire-2026-08-15.md`
**Author:** formal-verifier

---

## 0. What changed since the prior (STALE) revision — H3 correction

The previous revision of this doc claimed `VP-COMPONENT-014..020` were "not yet minted /
coverage gaps I-2..I-6" and were "RECOMMENDED for product-owner ratification." **That claim is
false as of the current BC bodies and is fully retracted here.** Ground-truth re-grep of the
`**Verification Properties**:` subsections across all four files confirms:

- **VP-COMPONENT-001..024 are ALL minted in the BC bodies.** The 014..020 range the prior doc
  called "gaps" is present (014 in BC-8.4.001, 015 in bc-2, 016 in BC-3.4.022, 017 in BC-8.2.007,
  018 in BC-8.3.003, 019 in BC-8.3.006, 020 in BC-2.3.040). The I-2..I-6 "coverage gap" entries
  are obsolete and removed.
- **The duplicate-VP-014 defect is resolved by the product-owner (M4 fix-burst).** BC-8.4.001
  keeps VP-COMPONENT-014 as its CANONICAL definition (resolver determinism + numeric-ID bypass).
  BC-8.4.005's case-insensitive-`ExactMultiple`/JQL-agreement claim, previously mis-numbered as a
  second, divergent VP-014, is split out to the new **VP-COMPONENT-021**. No id now carries two
  definitions.
- **Three further VPs were minted by the PO (M10 fix-burst):** VP-COMPONENT-022 (BC-8.1.005
  create POST body), VP-COMPONENT-023 (BC-8.1.007 edit partial PUT body), VP-COMPONENT-024
  (BC-8.2.008 delete 404 taxonomy).
- **VP-COMPONENT-020's subject type changed (M8 fix-burst):** the embedded component struct is
  now `Component { id: Option<String>, name: String }` (was `id: String`); the VP now pins both
  id-present and id-absent deserialization. Corrected below.

This doc is now purely a **formalization record** of the already-minted VPs — it proposes no new
VP for ratification. `verification-architecture/ARCH-INDEX.md` still does not exist (the whole
`verification-architecture/` directory is absent); VPs live inline in BC bodies, and this doc is
the standalone F2 formalization for the component bundle.

**Scheme in use:** `VP-COMPONENT-NNN`, 3-digit zero-padded, sequential. Precedent for a
feature-scoped VP namespace: `VP-576-*`, `VP-577-*`, `VP-590-*`, `VP-CITE-*`, `VP-CIGATE-*`,
`VP-MUTANTS-SCOPE-1-*`. The run was `001..024` as of the H3 refresh; this same-day
spec-tightening burst extends it to a complete, gapless, collision-free `001..026` (§7).

### 0.1 Full VP → BC home map (ground truth, current BC bodies)

| VP id | Home BC | File | One-line subject | Method |
|-------|---------|------|------------------|--------|
| VP-COMPONENT-001 | BC-8.1.003 | bc-8 | `--counts` N+1 call arity | WIREMOCK |
| VP-COMPONENT-002 | BC-8.1.006 | bc-8 | `--lead` resolve never partially mutates | WIREMOCK |
| VP-COMPONENT-003 | BC-8.2.001 | bc-8 | delete refuses without disposition | WIREMOCK |
| VP-COMPONENT-004 | BC-8.2.002 | bc-8 | `--move-to` resolves before DELETE | WIREMOCK |
| VP-COMPONENT-005 | BC-8.2.005 | bc-8 | self-move guard (ID equality) | WIREMOCK |
| VP-COMPONENT-006 | BC-8.2.006 | bc-8 | non-interactive `--orphan` needs `--yes` | INTEGRATION |
| VP-COMPONENT-007 | BC-8.2.006 | bc-8 | interactive decline aborts (exit 0) | INTEGRATION (TTY seam) |
| VP-COMPONENT-008 | BC-8.3.004 | bc-8 | rename `--dry-run` zero mutation | WIREMOCK |
| VP-COMPONENT-009 | BC-8.4.003 | bc-8 | ambiguous name → zero mutating HTTP | WIREMOCK |
| VP-COMPONENT-010 | BC-8.4.004 | bc-8 | cross-project non-collision | WIREMOCK |
| VP-COMPONENT-011 | BC-3.4.022 | bc-3 | single-key `--component` update-verb | WIREMOCK |
| VP-COMPONENT-012 | BC-3.4.023 | bc-3 | multi-key bulk wire shape (int componentId) | WIREMOCK **+ LIVE-JIRA** |
| VP-COMPONENT-013 | BC-2.1.022 | bc-2 | unresolvable `--component` filter → no search | WIREMOCK |
| VP-COMPONENT-014 | BC-8.4.001 | bc-8 | **CANONICAL** resolver determinism + numeric bypass | PROPTEST + UNIT |
| VP-COMPONENT-015 | BC-2.1.007/018/019/020/021 | bc-2 | filter-operator composition + stable ordering | UNIT (+ optional proptest) |
| VP-COMPONENT-016 | BC-3.4.022 | bc-3 | add/remove don't-clobber + editmeta fallback | WIREMOCK |
| VP-COMPONENT-017 | BC-8.2.007 | bc-8 | snapshot-before-DELETE ordering + fail-closed | WIREMOCK |
| VP-COMPONENT-018 | BC-8.3.003 | bc-8 | rename fan-out atomicity + partial-fail exit | WIREMOCK |
| VP-COMPONENT-019 | BC-8.3.006 | bc-8 | case-only rename not short-circuited | WIREMOCK |
| VP-COMPONENT-020 | BC-2.3.040 | bc-2 | `Component { id: Option<String> }` serde | UNIT (serde) |
| VP-COMPONENT-021 | BC-8.4.005 | bc-8 | case-insensitive `ExactMultiple`/JQL agreement | PROPTEST + UNIT |
| VP-COMPONENT-022 | BC-8.1.005 | bc-8 | create POST body (omit-if-absent, enum) | WIREMOCK |
| VP-COMPONENT-023 | BC-8.1.007 | bc-8 | edit partial PUT body (`--lead ""`→null) | WIREMOCK |
| VP-COMPONENT-024 | BC-8.2.008 | bc-8 | delete 404 taxonomy (resolver-64 vs race-1) | WIREMOCK |
| VP-COMPONENT-025 | BC-3.4.024, BC-3.4.025 | bc-3 | `issue create --component` body composition + resolver mechanism | WIREMOCK |
| VP-COMPONENT-026 | BC-8.3.002 | bc-8 | `--all-projects` numeric-`OLD` rejection + exact-equality matching | WIREMOCK/UNIT |
| VP-COMPONENT-027 | BC-3.4.020 | bc-3 | `--label`+`--component` mutual-exclusion exit-64 (zero PUT/bulk-POST) | WIREMOCK/UNIT |
| VP-COMPONENT-028 | BC-3.4.021 | bc-3 | dry-run `plannedChanges.components` flat-array shape | WIREMOCK/UNIT |

VP-COMPONENT-015 is one property that spans five BC bodies (the five `--component` filter
shapes + amended ordering) — a single VP referenced from each, not five definitions.
VP-COMPONENT-025 is one property that spans two BC bodies (BC-3.4.024's create-path body
composition, BC-3.4.025's resolver-mechanism decision) — likewise a single VP referenced from
each, not two definitions. All other VPs have exactly one home BC.

**Note (P7 fix-burst):** BC-3.4.017's `components`-field extension to Gate B (flag-overlap
exit-64, EC-3.4.017-15) is intentionally NOT given a `VP-COMPONENT-0xx` id — it is pinned by the
pre-existing BASE property **VP-396-005** (`bc-3-issue-write.md`, updated in-place at issue #605
F2 to enumerate `summary`/`description`/`issuetype`/`priority`/`components` as its five-member
Gate B set), which predates and is outside the `VP-COMPONENT-*` feature-scoped namespace. §3 now
cites VP-396-005 explicitly for BC-3.4.017 rather than leaving it unlisted.

---

## 1. Formalized minted VPs (VP-COMPONENT-001..028)

Each entry restates the property precisely, names the BC(s) it verifies, and records the
verification method + test-family tag (`WIREMOCK` / `INTEGRATION` / `PROPTEST` / `UNIT` /
`LIVE-JIRA`). §1.1 covers 001..013 (unchanged from the prior revision except VP-009's
already-applied narrowing); §1.2 covers 014..024 (the range the prior revision wrongly called
"not minted", plus the three M10 additions); §1.3 covers 025..026 (spec-tightening burst, §7);
§1.4 (new, §12) covers 027..028 (pass-7 fix-burst).

### 1.1 VP-COMPONENT-001..013

#### VP-COMPONENT-001 — `--counts` N+1 call arity
- **Property:** `jr component list --counts` issues exactly one
  `GET /rest/api/3/component/{id}/relatedIssueCounts` per component in the list response
  (`.expect(N)`); a plain `list` issues zero (`.expect(0)`). Zero-component project → zero
  enrichment calls; a single enrichment 5xx → that row `?`/`null`, stderr warning, exit 0.
- **Verifies:** BC-8.1.003 (EC-8.1.003-1/2).
- **Method:** `WIREMOCK` — call-count pins on `relatedIssueCounts`; N=0 fixture; fail-soft sub-case.

#### VP-COMPONENT-002 — lead resolution never partially mutates
- **Property:** Ambiguous / no-match `--lead` on `create` issues zero `POST /rest/api/3/component`
  (`.expect(0)`); same on `edit` for the `PUT` (`.expect(0)`). Exit 64. **[EXTENDED 2026-08-15,
  P4 fix-burst — closes a formalization-drift gap found by adversarial spec-delta review pass 4,
  MEDIUM-1]** `create --lead ""` (empty string) is also covered by this zero-`POST` pin: it is
  rejected by an explicit application-level guard BEFORE the assignable-user resolver is even
  invoked (no resolver search attempted at all, distinct from the ambiguous/no-match cases
  above, which do invoke the resolver and then find 0 or 2+ matches) — exit 64, zero HTTP.
- **Verifies:** BC-8.1.006 (Invariant 1, EC-8.1.006-1/2/3; **[EXTENDED 2026-08-15, P4
  fix-burst]** VP-COMPONENT-002's own H2 extension in BC-8.1.006's Verification Properties
  section, which this entry previously omitted — the BC body already stated VP-COMPONENT-002
  was extended to cover EC-8.1.006-3; this formalization record now matches it).
- **Method:** `WIREMOCK` — assignable-user search returns 0 / 2+; `.expect(0)` on create POST /
  edit PUT. A THIRD fixture (P4 fix-burst addition) issues `create --lead ""` with NO
  assignable-user-search mock mounted at all and asserts `.expect(0)` on `POST` — confirming the
  app-level empty-lead-on-create guard fires before any resolver HTTP, not merely before the
  final `POST`.

#### VP-COMPONENT-003 — delete refuses without a disposition
- **Property:** With neither `--move-to` nor `--orphan`, `DELETE /rest/api/3/component/{id}` is
  never called (`.expect(0)`), regardless of whether the target resolves.
- **Verifies:** BC-8.2.001 (Invariant 2; EC-8.2.001-1/3, incl. the Invariant-1 not-found-first ordering).
- **Method:** `WIREMOCK` — `.expect(0)` on DELETE; target-resolution GET may fire.

#### VP-COMPONENT-004 — `--move-to` resolves before DELETE
- **Property:** Ambiguous / unknown `--move-to` target → `DELETE` never called (`.expect(0)`),
  exit 64. Includes BC-8.2.003's cross-project case (target matching only in another project =
  "no match in scope"). **[EXTENDED 2026-08-15, M2 fix-burst]** For a NUMERIC `--move-to`
  value specifically, `jr` fires exactly one `GET /rest/api/3/component/{targetId}` (BC-8.2.002's
  numeric-target confirmation GET — the concrete mechanism resolving the previously-unspecified
  "numeric bypass validates project membership" claim) BEFORE the `DELETE`; a project-field
  mismatch on that GET response (or a 404 on the GET itself) is the numeric-path instantiation
  of "no match in scope" and is covered by this same `.expect(0)`-on-DELETE pin. **[EXTENDED
  2026-08-15, M1 fix-burst — pass 3, closes the numeric-SOURCE-project-validation gap found by
  adversarial spec-delta review pass 3]** For a NUMERIC SOURCE `NAME|ID` (the positional being
  deleted, not `--move-to`), `jr` fires the SYMMETRIC `GET /rest/api/3/component/{sourceId}`
  (BC-8.2.002 Precondition 3/Postcondition 3) and compares its `project` field against a
  supplied `--project KEY`; a mismatch → exit 64 pre-flight, `.expect(0)` on BOTH the
  `--move-to` resolution GET and `DELETE` — this closes the gap where `jr component delete
  20007 --project A --move-to Frontend` (id `20007` actually in project B) would otherwise
  scope `--move-to Frontend`'s resolution to the wrong project. **[EXTENDED 2026-08-15, P5
  fix-burst — pass 5, resolves MED-1/LOW-1 found by adversarial spec-delta review pass 5]**
  This SAME numeric-source confirming-`GET`/mismatch mechanism now ALSO fires for TWO further
  caller-side usages beyond `delete`'s SOURCE and TARGET: `edit`'s own numeric `NAME|ID`
  (BC-8.1.007 M1, new) and `rename`'s numeric `OLD` (BC-8.3.001 M1, new). `edit` uses the
  derived project both for the mismatch check AND to scope `--lead` resolution/cache
  invalidation when no `--project`/config was supplied; `rename`'s single-project form always
  has a REQUIRED `--project KEY`, so its numeric `OLD` uses the confirming `GET` purely for the
  mismatch check. VP-COMPONENT-004 is therefore the general "numeric-bypass caller-side
  project-confirmation" property, with FOUR caller-side instantiations as of this fix-burst:
  `delete` SOURCE, `delete --move-to` TARGET, `edit` `NAME|ID`, `rename` `OLD`.
- **Verifies:** BC-8.2.002 (Postcondition 1, Precondition 3/Postcondition 3), BC-8.2.003 (incl.
  EC-8.2.003-2), BC-8.2.004; BC-8.1.007 (Precondition 3/Postcondition 3, EC-8.1.007-4, P5
  fix-burst); BC-8.3.001 (Precondition 3/Postcondition 3, EC-8.3.001-1, P5 fix-burst).
- **Method:** `WIREMOCK` — `.expect(0)` on DELETE; source-project list mounted, target absent/duplicated
  (name-form case); a dedicated fixture for the numeric-form case mounts
  `GET /rest/api/3/component/{targetId}` returning a DIFFERENT project's key and asserts the
  confirmation GET fires exactly once and `DELETE` is never called. A THIRD fixture (pass-3
  addition) mounts `GET /rest/api/3/component/{sourceId}` returning a project that mismatches a
  supplied `--project KEY` and asserts `.expect(0)` on BOTH the `--move-to` target-resolution GET
  and `DELETE` (EC-8.2.002-1). A FOURTH and FIFTH fixture (P5 fix-burst addition) mount the same
  mismatch shape for `edit`'s `PUT` (`.expect(0)`, EC-8.1.007-4) and `rename`'s `PUT`
  (`.expect(0)`, EC-8.3.001-1) respectively.

#### VP-COMPONENT-005 — self-move guard (ID equality)
- **Property:** Resolved source id == resolved target id → `DELETE` never called (`.expect(0)`),
  exit 64. Fires on id equality (catches same-name and mixed name/numeric-id forms).
- **Verifies:** BC-8.2.005 (EC-8.2.005-1/2).
- **Method:** `WIREMOCK` — `.expect(0)` on DELETE for both EC forms.

#### VP-COMPONENT-006 — non-interactive `--orphan` requires `--yes`
- **Property:** Non-interactive (`--no-input` or non-TTY) `--orphan` without `--yes` → `DELETE`
  never called (`.expect(0)`), exit 64. **[EXTENDED 2026-08-15, L3 fix-burst — pass 3, closes a
  firing-boundary/message-completeness gap found by adversarial spec-delta review pass 3]** The
  stderr exit-64 message contains the real, snapshot-derived affected-issue count `<N>` — the
  BC-8.2.007 snapshot fires BEFORE this `--yes`-required check is evaluated (BC-8.2.006
  Invariant 2), not only before the interactive prompt, so `<N>` is never a placeholder or an
  omitted value in this non-interactive path either.
- **Verifies:** BC-8.2.006 (non-interactive Postcondition 2; EC-8.2.006-3/4).
- **Method:** `INTEGRATION` (assert-cmd + wiremock) — subprocess, non-TTY stdin; `.expect(0)`.
  A dedicated fixture (pass-3 addition) mounts a non-zero affected-issue snapshot result (e.g.
  7 issues) and asserts the exit-64 stderr message contains the literal `7` — confirming the
  snapshot search fired before the `--yes` check ran (EC-8.2.006-4).

#### VP-COMPONENT-007 — interactive decline aborts cleanly
- **Property:** Interactive `--orphan`, user declines → `DELETE` never called (`.expect(0)`);
  exit **0** (declined confirmation is not an error).
- **Verifies:** BC-8.2.006 (interactive Postcondition 2).
- **Method:** `INTEGRATION` — needs the debug-only TTY seam (`JR_STDIN_IS_TTY=1`, per the
  `tests/comment_delete.rs` VP-577-013/030 precedent) + scripted `n`/Enter on stdin; `.expect(0)`,
  exit 0. No network beyond wiremock. Depends on the established comment-delete confirmation seam.

#### VP-COMPONENT-008 — rename `--dry-run` zero mutation
- **Property:** `--dry-run` (either `--project` or `--all-projects`) issues zero
  `PUT /rest/api/3/component/{id}` (`.expect(0)`); read-only discovery still runs (Invariant-1
  dry-run/live scope parity).
- **Verifies:** BC-8.3.004 (Invariant 2; EC-8.3.004-1).
- **Method:** `WIREMOCK` — `.expect(0)` on PUT; assert discovery GET(s) still fire.

#### VP-COMPONENT-009 — ambiguous name → zero mutating HTTP (mutating consumers)
- **Property:** An ambiguous component name on any genuinely-**mutating** consuming command
  (edit / delete / rename / `--move-to` / `issue edit --component`) issues zero mutating HTTP
  (`.expect(0)` on the relevant PUT/POST/DELETE); the ambiguity fires before any of them.
- **Verifies:** BC-8.4.003 (and transitively the shared BC-X.10.001 fail-closed invariant).
- **Method:** `WIREMOCK` — parametrized across the mutating consumers; `.expect(0)` on each route.
- **Note (I-1, RESOLVED in BC body):** The PO already narrowed this VP's wording (issue #605/#606
  F2) to EXCLUDE the read-only `issue list --component` path — that path's correct pin is
  VP-COMPONENT-013 (`.expect(0)` on `POST /rest/api/3/search/jql`), not a mutation `.expect(0)`.
  The prior over-broad wording no longer stands in the BC body.

#### VP-COMPONENT-010 — cross-project non-collision
- **Property:** Two projects each with a component named "Backend" (different ids);
  `--component Backend` scoped to Project A resolves to A's id at every consuming call site
  (issue edit, issue list filter, component edit, component delete `--move-to`); Project B's
  component-list endpoint is never called (`.expect(0)`).
- **Verifies:** BC-8.4.004, supports BC-8.2.003.
- **Method:** `WIREMOCK` — two-project fixture; `.expect(0)` on B's `/project/{B}/components`;
  positive assertion resolved id == A's.

#### VP-COMPONENT-011 — single-key `--component` uses native update-verb
- **Property:** Single-key `issue edit --component` calls `PUT /rest/api/3/issue/{key}` exactly
  once with the native `update`-verb object-form body
  (`{"update":{"components":[{"add":…},{"remove":…}]}}`); the bulk endpoint
  `POST /rest/api/3/bulk/issues/fields` is never hit (`.expect(0)`).
- **Verifies:** BC-3.4.022 (Postconditions 1–2, Invariant 1).
- **Method:** `WIREMOCK` — body-shape match (ADD-before-REMOVE) + `.expect(0)` on the bulk route.
  (Editmeta-gated fallback correctness is VP-COMPONENT-016.)

#### VP-COMPONENT-012 — multi-key bulk wire shape (integer componentId) — LIVE-JIRA REQUIRED
- **Property:** A multi-key `--component` invocation issues zero single-key
  `PUT /rest/api/3/issue/{key}` (`.expect(0)`); the bulk POST body carries
  `selectedActions:["components"]` and `editedFieldsInput.multiselectComponents` with
  `components[].componentId` values that are JSON **integers** (not strings, not `{"name":…}`),
  and `bulkEditMultiSelectFieldOption` ∈ {ADD, REMOVE, REPLACE, REMOVE_ALL}. Both-add-and-remove
  → two sequential POSTs (ADD then REMOVE). **[CORRECTED 2026-08-15, I1 fix-burst — pass 3,
  aligns this restatement with BC-3.4.023 Postcondition 6, closing an under-specified-wording
  finding from adversarial spec-delta review pass 3]** A resolved key set > 1000 issues →
  `ceil(N/1000)` sequential POSTs PER ACTION — `ceil(N/1000)` for a single-action invocation
  (only `add:` or only `remove:` specs present), or `2 * ceil(N/1000)` when BOTH `add:` and
  `remove:` specs are present in one invocation (chunk-major, action-minor ordering: chunk
  first, then within each chunk issue the ADD-then-REMOVE pair) — each fully polled before the
  next. **Previous version (superseded, retained for audit trail):** "A resolved key set >
  1000 issues → `ceil(N/1000)` sequential POSTs, each fully polled before the next" — this
  omitted the per-action multiplier for the mixed add:+remove: case, which BC-3.4.023
  Postcondition 6 already specified (`2 * ceil(N/1000)` total POSTs when both actions and
  >1000 issues occur together); the restatement now matches the BC verbatim.
- **Verifies:** BC-3.4.023 (Postconditions 1–6; EC-3.4.023-2/4).
- **Method:** `WIREMOCK` for the emitted shape (integer-type assertion, camelCase/lowercase
  asymmetry, `.expect(0)` on single-key PUT) **+ `LIVE-JIRA` (REQUIRED)**. Per DEC-280 the shape is
  triple-corroborated in docs but never confirmed against a live run; wiremock proves only that
  `jr` *emits* the documented shape, not that live Jira *accepts* it. **[SCOPED 2026-08-15, pass-10
  fix-burst — resolves MEDIUM-1 found by adversarial spec-delta review pass 10]** F4/F6 MUST gate
  shipping behind a live smoke test of **1×ADD, 1×REMOVE across ≥2 issues in one project**, async
  task polled to success, per the `FIX-BULK-TRANSITION-001`/#446 precedent — scoped to the two
  operations `jr` actually emits (BC-3.4.023 Postcondition 3: a bare `--component X` resolves to
  ADD; a mixed `add:`+`remove:` invocation issues two sequential POSTs, ADD then REMOVE; `jr` has
  no `set:`/`replace:`/`clear:` CLI grammar and therefore never constructs a `REPLACE`/
  `REMOVE_ALL` request body). `REPLACE`/`REMOVE_ALL` are wire-schema-completeness enum values the
  endpoint accepts (Postcondition 3's `ADD | REMOVE | REPLACE | REMOVE_ALL` listing) but `jr`
  does NOT generate with any current CLI grammar — they are intentionally OUT of scope for this
  jr-gated live smoke test. Do NOT add a `replace:`/`set:` CLI grammar to exercise them; that is
  `#607` territory, out of scope for this bundle. **Previous version (superseded, retained for
  audit trail):** "F4/F6 MUST gate shipping behind a live smoke test (1×ADD, 1×REMOVE, 1×REPLACE
  across ≥2 issues in one project, async task polled to success)" — this mandated a REPLACE call
  `jr` never issues in production, an unsatisfiable acceptance criterion. A live contradiction on
  the ADD/REMOVE shape requires correcting BC-3.4.023 + this VP to the observed shape. **This is
  the one VP in the bundle not fully dischargeable by wiremock alone.**

#### VP-COMPONENT-013 — unresolvable/ambiguous `--component` filter → no search
- **Property:** An unresolvable/ambiguous `--component` value (bare, `not:`, or within an `all:`
  list) → `POST /rest/api/3/search/jql` is never called (`.expect(0)`), exit 64, before the issue
  search fires. (`none` keyword is excluded — no resolver round-trip; its no-project guard is
  BC-2.1.022 EC-2.1.022-2, covered by VP-COMPONENT-015.)
- **Verifies:** BC-2.1.022.
- **Method:** `WIREMOCK` — `.expect(0)` on the JQL search route; component-list GET may fire.

### 1.2 VP-COMPONENT-014..024

#### VP-COMPONENT-014 — resolver determinism + numeric-ID bypass (CANONICAL) — PROPTEST + UNIT
- **Property:** `resolve_component(input, project, candidates)` is deterministic (same
  input+candidate list → same `MatchResult`) and never panics on arbitrary input; all-ASCII-digit
  `input` short-circuits to the numeric-id path **without** consulting `partial_match` or fetching
  the candidate list (zero resolver GET fired for a numeric id).
- **Verifies:** BC-8.4.001 (Invariants 1–2). Transitively supports the numeric-bypass behavior of
  BC-8.1.008 (which has no VP subsection of its own — see residual R-1).
- **Method:** `PROPTEST` (pure-function: determinism, non-panic, exact-match-always-found,
  empty-candidates → None — mirrors BC-X.10.002's `partial_match` proptest) **+ UNIT** for the
  numeric-bypass branch (all-digit input, no GET fired).
- **Mutation note:** `resolve_component` (new, `src/cli/issue/helpers.rs`) is a strong
  `.cargo/mutants.toml` `examine_globs` candidate — this proptest is its primary kill vehicle
  (add in F6).
- **Canonicalization note:** This is the SOLE definition of VP-COMPONENT-014. BC-8.4.005's
  case-insensitive-agreement claim (formerly mis-numbered VP-014) is now VP-COMPONENT-021.

#### VP-COMPONENT-015 — filter-operator composition + stable clause ordering — UNIT
- **Property:** `build_filter_clauses` emits the four `--component` operator shapes exactly:
  bare/repeated → `component in (id1, id2, …)` (input order, single clause); `not:` → the single,
  always-parenthesized `(component not in (…) OR component is EMPTY)` group (multiple `not:` values
  within one group; a bare-list and a `not:`-list MAY coexist, AND-joined bare-then-`not:`); `none`
  → `component is EMPTY` with zero resolver HTTP (given a project scope); `all:` → `component = id1
  AND component = id2 …` (AND-joined, never `IN`). The `--component` clause holds its pinned
  position (after `asset`, before date-range) via `Vec<String>` positional equality. Combination
  guards — `none`+any-other, `all:`+bare/`not:`/`none`, repeated `all:`, and `none`/bare/`not:`/`all:`
  with no project scope — are exit-64 pre-flight (no HTTP).
- **Verifies:** BC-2.1.018, BC-2.1.019, BC-2.1.020, BC-2.1.021, BC-2.1.007 (amended ordering).
- **Method:** `UNIT` — string-equality on composed clauses + positional-equality on the clause
  vector (same discipline as existing `build_jql_parts_*` tests); combination/no-scope guards as
  exit-64 pre-flight assertions (no HTTP). Optional small `PROPTEST` for order-stability across
  arbitrary flag subsets.

#### VP-COMPONENT-016 — add/remove don't-clobber + editmeta-gated fallback — WIREMOCK
- **Property:** Single-key `--component add:X --component remove:Y` preserves every OTHER component
  already on the issue (the `update`-verb body touches only X/Y). When editmeta advertises
  `components.operations` containing `add`/`remove`, the native `update`-verb PUT is used directly;
  when it does NOT, `jr` falls back to GET-current → compute → `set`-verb PUT
  (`{"fields":{"components":[…]}}`). The editmeta gate is evaluated at most once (no
  retry-with-different-shape on a subsequent 400).
- **Verifies:** BC-3.4.022 (Postcondition 3, Invariant 2).
- **Method:** `WIREMOCK` — two fixtures (editmeta advertises ops → update-verb path; editmeta omits
  ops → read-modify-write path); body-match asserts untouched components survive in both.

#### VP-COMPONENT-017 — snapshot-before-DELETE ordering, full pagination, and fail-closed — WIREMOCK
- **Property:** For a chosen, guard-cleared disposition (`--move-to` or `--orphan` — NOT the
  no-disposition exit-64 path, per BC-8.2.001/BC-8.2.007 Postcondition 1, corrected M3
  fix-burst), the read-only JQL snapshot (`POST /rest/api/3/search/jql`, clause ALWAYS
  `component = <resolvedId> ORDER BY key ASC` **[UPDATED 2026-08-15, H1 fix-burst — pass 3:
  the trailing `ORDER BY key ASC` is now mandatory]** — numeric id, NEVER `component =
  "<name>"`, per BC-8.2.007 Postcondition 4) fires exactly once, iterates ALL cursor-pagination
  pages to completion before composing `affectedIssueCount`/`affectedIssues` (BC-8.2.007
  Postcondition 5, M1 fix-burst), and strictly BEFORE the `DELETE`. A snapshot-search failure
  (5xx/network, including a failure mid-pagination) aborts before the DELETE (`.expect(0)` on
  DELETE) — fail-closed. **[EXTENDED 2026-08-15, H1 fix-burst — pass 3, closes a silent-
  undercount gap found by adversarial spec-delta review pass 3]** "Fail-closed on
  failure mid-pagination" explicitly INCLUDES the JRACLOUD-95368 anti-loop drift guard's
  `has_more=true` partial-result abort — which is a SUCCESSFUL Rust return (not an `Err`) from
  the shared `search_issue_keys`-style pagination loop this snapshot reuses. A loop that exits
  via the anti-loop guard (drift detected, partial deduped key set returned with
  `has_more=true`) MUST be treated identically to a transport-level fetch failure: abort before
  `DELETE`, zero `DELETE` calls, no confirmation prompt/message shown using the partial count.
  Only a loop that completes normally (no `nextPageToken` remaining, anti-loop guard never
  triggered) may be used to compose `affectedIssueCount`/`affectedIssues`.
- **Verifies:** BC-8.2.007 (Postconditions 1–5), supports BC-8.2.008's `affectedIssues` payload.
- **Method:** `WIREMOCK` — request-ordering assertion (snapshot before DELETE) + a snapshot-5xx
  fixture asserting `.expect(0)` on DELETE + a no-disposition fixture asserting `.expect(0)` on
  the snapshot search itself (Postcondition 1 boundary) + a ≥2-page `nextPageToken` fixture
  asserting every page is fetched and the composed count/key-list reflects the full multi-page
  result, not just the first page. **Ordering pins are load-bearing** — a reorder mutant
  must fail. A two-project same-name fixture (mirrors VP-COMPONENT-010) MUST assert the snapshot
  JQL body carries the resolved id, not the shared name — an id→name swap mutant must fail. A
  JQL-body assertion (pass-3 addition) MUST also assert the composed clause ends with `ORDER BY
  key ASC` — a mutant that drops the `ORDER BY` clause must fail. **A dedicated anti-loop-drift
  fixture (pass-3 addition)** simulates the JRACLOUD-95368 abort condition (e.g. a
  `nextPageToken` sequence that never terminates, or overlapping-key pages that trip the
  anti-loop guard) and asserts `.expect(0)` on `DELETE` — a mutant that treats the anti-loop
  guard's `has_more=true` partial return as "pagination completed successfully" must fail this
  assertion. **[EXTENDED 2026-08-15, pass-11 fix-burst — resolves LOW-2 found by adversarial
  spec-delta review pass 11]** The same anti-loop-drift fixture MUST ALSO assert (a) the process
  exits 1, and (b) the error output contains the substring "could not reliably enumerate affected
  issues — aborting delete" — parity with BC-8.2.007 Postcondition 5's pass-10 synthesized-error
  contract. `.expect(0)` on `DELETE` alone is necessary but not sufficient: a mutant that
  correctly aborts the DELETE but exits 0, or exits 1 with an unrelated/generic message, must fail
  this fixture. **[CLARIFIED 2026-08-15, pass-14 fix-burst — resolves LOW-1 found by
  adversarial spec-delta review pass 14]** The exit-1 outcome asserted here is sourced from a
  dedicated, purpose-built `JrError` variant (e.g. `JrError::SnapshotIncomplete`, per
  BC-8.2.007 Postcondition 5's pass-14 correction) — NOT `JrError::UserError` (which exits 64)
  and NOT `JrError::Internal` (reserved for "should never happen" bugs). This fixture asserts
  the exit code and message only, not the specific `JrError` variant name (opaque to a
  wiremock/CLI-boundary test), so no fixture change is required by this correction — it is
  documented here purely to keep BC-8.2.007, the prd-delta taxonomy row, and this VP naming
  the same concrete exit-1 mechanism.

#### VP-COMPONENT-018 — rename fan-out per-project atomicity + partial-failure exit — WIREMOCK
- **Property:** Under `--all-projects`, a per-project `PUT` failure does not roll back an
  already-committed rename in another project and does not stop attempts on remaining matched
  projects (continue-on-error). Exit 0 iff every attempted project succeeded; exit 1 if ≥1 failed;
  JSON reports `renamed[]` and `failed[]`.
- **Verifies:** BC-8.3.003 (Postconditions 1–2; EC-8.3.003-1/2), supports BC-8.3.002.
- **Method:** `WIREMOCK` — multi-project fixture with one PUT returning 400; assert the other PUTs
  still fire, exit code 1, and the JSON outcome arrays.

#### VP-COMPONENT-019 — case-only rename is not short-circuited — WIREMOCK
- **Property:** `rename Backend backend` resolves `Backend` case-insensitively and still issues
  `PUT {"name":"backend"}` (`.expect(1)`) — the PUT is NOT skipped merely because
  `OLD.to_lowercase() == NEW.to_lowercase()`. **[EXTENDED 2026-08-15, L6 fix-burst — pass 3,
  closes a coverage gap found by adversarial spec-delta review pass 3]** This property ALSO
  covers the `--all-projects` fan-out (BC-8.3.002), whose per-project match is EXACT
  case-insensitive equality, NOT §8.4's `partial_match` — the no-short-circuit rule applies
  identically there: `rename Backend backend --all-projects`, with Projects A and B each having
  a component named exactly `"Backend"`, MUST NOT skip either project's `PUT` merely because
  `OLD.to_lowercase() == NEW.to_lowercase()`.
- **Verifies:** BC-8.3.006 (EC-8.3.006-1/2).
- **Method:** `WIREMOCK` — assert exactly one PUT with body `{"name":"backend"}` for a
  single-project case-only rename. A SECOND fixture (pass-3 addition) covers `--all-projects`:
  two projects each with a component named exactly `"Backend"`, invoked as `rename Backend
  backend --all-projects`, asserting BOTH projects' `PUT {"name":"backend"}` calls fire
  (`.expect(1)` per project, `.expect(2)` total) — a mutant that special-cases
  `OLD.to_lowercase() == NEW.to_lowercase()` as a skip condition anywhere in the `--all-projects`
  fan-out must fail this assertion identically to the single-project case.

#### VP-COMPONENT-020 — embedded `Component` struct id deserialization (optional id) — UNIT (serde)
- **Property:** `Component { id: Option<String>, name: String }` deserializes both fields from
  `{"id":"…","name":"…"}` (`id: Some(...)`) AND from `{"name":"…"}` alone (`id: None`, no
  deserialization error — M8 fix-burst EC-2.3.040-2: a component entry inside `fields.components[]`
  omitting `id` does not fail the whole-issue deserialization; display renders `name` only). The
  embedded type stays DISTINCT from the full `types/jira/component.rs` resource type, whose `id`
  remains required (BC-2.3.040 Precondition 1).
- **Verifies:** BC-2.3.040 (Postconditions 1–2, EC-2.3.040-1/2).
- **Method:** `UNIT` — serde round-trip with id-present and id-absent fixtures; a separate assertion
  that the full-resource type still requires `id`.
- **Correction note:** The prior revision of this doc described this struct as `id: String` and a
  "boundary" id-absent case as an error — that is now wrong; the PO's M8 fix-burst made `id`
  `Option<String>` and id-absent a SUCCESS path. Updated accordingly.

#### VP-COMPONENT-021 — case-insensitive `ExactMultiple`/JQL agreement — PROPTEST + UNIT
- **Property:** `partial_match`'s case-insensitive exact-match handling
  (`name.to_lowercase() == input.to_lowercase()`, BC-X.10.003) makes the client-side resolver agree
  with JQL's own case-insensitive `component = "..."` matching — `--component backend` resolves the
  same component JQL matches for a stored `"Backend"`. Where two same-project names differ only by
  case, `partial_match`'s `ExactMultiple` path treats both as valid exact matches (no false
  `Ambiguous`). This VP does NOT assert whether Jira permits such a same-case-collision state.
- **Verifies:** BC-8.4.005.
- **Method:** `PROPTEST + UNIT` — covered by the SAME determinism/numeric-bypass suite as
  VP-COMPONENT-014, extended with the case-only agreement case (`Backend`↔`backend`). Pure-function,
  offline.
- **Split note:** Formerly mis-numbered VP-COMPONENT-014 (duplicating BC-8.4.001's distinct claim);
  renumbered to 021 by the PO (M4 fix-burst). No behavioral content changed — only the id.

#### VP-COMPONENT-022 — create POST body: omit-if-absent + assigneeType enum — WIREMOCK
- **Property:** `POST /rest/api/3/component` body contains the `description` / `leadAccountId` /
  `assigneeType` keys ONLY when the corresponding flag was supplied — an absent
  `--description`/`--lead`/`--assignee-type` produces NO key in the body (never sent as `null`).
  When all three are supplied, the body contains EXACTLY `name`, `project`, `description`,
  `leadAccountId`, `assigneeType` and no other keys. `assigneeType` values are constrained to the
  four-member enum (`PROJECT_LEAD`, `COMPONENT_LEAD`, `UNASSIGNED`, `PROJECT_DEFAULT`); an
  out-of-enum value is exit-2 pre-flight (clap `value_parser`/`ValueEnum` rejection, zero HTTP)
  **[CORRECTED 2026-08-15, H2 fix-burst, DEC-188]**.
- **Verifies:** BC-8.1.005 (Behavior body-shape; EC-8.1.005-2).
- **Method:** `WIREMOCK` — body-match asserting each omitted key is ENTIRELY ABSENT (not `null`);
  a full-flags fixture asserting the exact 5-key set; a clap-level exit-2 assertion for the
  out-of-enum `--assignee-type` (no HTTP; process-level assertion, not wiremock, since no
  request is ever sent). **Previous version (superseded):** asserted "clap-level exit-64" for
  the out-of-enum case — a clap `value_parser`/`ValueEnum` rejection is always exit 2, never the
  app's own exit 64 (DEC-188's exit-code class); the mechanism (clap-level, zero HTTP)
  was already correct, only the exit code was wrong. Fully offline.

#### VP-COMPONENT-023 — edit partial PUT: only-supplied fields + `--lead ""`→null — WIREMOCK
- **Property:** `PUT /rest/api/3/component/{id}` body contains EXACTLY the keys for the flags
  supplied. `--name` alone → body is `{"name":"…"}` only (no `description`/`leadAccountId`).
  `--lead ""` (empty string, `edit` only) → body contains `"leadAccountId": null` (explicit clear),
  DISTINCT from an omitted `--lead`, which sends no `leadAccountId` key at all. `--name`+`--lead ""`
  → body is exactly `{"name":"…", "leadAccountId": null}`, no `description` key. Supplying none of
  `--name`/`--description`/`--lead` → exit 64 pre-flight, zero HTTP. **[CLARIFIED 2026-08-15, P16
  fix-burst — resolves MED-1 found by adversarial spec-delta review pass 16]** The no-fields
  zero-HTTP assertion holds for BOTH a NAME and a numeric `NAME|ID` — a fixture using a NAME
  input on a cold (unwarmed) component-list-cache wiremock server MUST `.expect(0)` on the
  `GET /project/{key}/components` resolution call, not only on the `PUT`, since BC-8.1.007's
  Precondition 1 (no-fields check) now fires before Precondition 2 (§8.4 resolution) as well as
  before Precondition 3 (the numeric-source confirming `GET`). **Previous version (superseded,
  retained for audit trail; pre-P16):** this property's "zero HTTP" language did not distinguish
  which HTTP call(s) a NAME-input fixture must assert zero of; before the fix, BC-8.1.007's own
  Precondition ordering note only guaranteed this for the numeric-source confirming `GET`, so a
  NAME-input fixture that only asserted `.expect(0)` on the `PUT` (not on the resolution `GET`)
  would not have caught the underlying precondition-ordering defect this pass found.
- **Verifies:** BC-8.1.007 (Postconditions 1–2; EC-8.1.007-1, EC-8.1.007-7).
- **Method:** `WIREMOCK` — body-match on the exact key set per flag combination; explicit
  presence-of-`null` assertion for `--lead ""` vs. absence-of-key for omitted `--lead`; an
  exit-64/zero-HTTP assertion for the no-fields case, asserting `.expect(0)` on BOTH the §8.4
  resolution `GET` (NAME input) and the numeric-source confirming `GET` (numeric input), not
  merely on the `PUT`. Fully offline.

#### VP-COMPONENT-024 — delete 404 taxonomy: resolver-404 (exit 64) vs race-404 (exit 1) — WIREMOCK
- **Property:** SOURCE `NAME|ID` not found at resolution time → exit 64 (`JrError::UserError`,
  ordinary not-found path, BC-8.1.008), zero `DELETE` calls — NOT exit-0/idempotent-skip. A `DELETE`
  call that itself races and 404s AFTER a successful resolution (source OR `--move-to` target,
  EC-8.2.008-1) → exit 1 (`JrError::ApiError(404)`). The two 404 sources (resolver-layer vs.
  DELETE-call-layer) are DISTINGUISHABLE by exit code (64 vs. 1) and MUST NOT be collapsed into a
  single "component delete is idempotent" behavior. **[EXTENDED 2026-08-15, P5 fix-burst — pass
  5, resolves LOW-3 found by adversarial spec-delta review pass 5]** This exact taxonomy — a
  resolver-layer/confirming-GET 404 is exit 64 (ordinary not-found); a mutating-call 404 AFTER a
  SUCCESSFUL resolution is exit 1 (genuine race) — is now UNIFORM across all three mutating
  commands, not `delete`-only: `edit`'s `PUT` (BC-8.1.007's Idempotency section, EC-8.1.007-5)
  and `rename`'s `PUT` (BC-8.3.001's Idempotency section, EC-8.3.001-2) both extend this same
  property to their own mutating call rather than defining a divergent one. This also closes the
  message-composition gap identified alongside the taxonomy asymmetry: BC-8.1.008's not-found
  message now has an explicit project-less variant (`"Component '<input>' not found. Run: jr
  component list --project <KEY> to see valid components."`) for the case where the 404'd
  confirming `GET` is itself the only source that could have derived a project (numeric
  `edit`/`delete`/`rename` with no `--project`/config and no prior successful confirming GET in
  the same invocation) — the pre-P5 message assumed `<key>` was always available, which it is
  not in this specific shape.
- **Verifies:** BC-8.2.008 (Idempotency clause; EC-8.2.008-1); BC-8.1.007 (Idempotency clause;
  EC-8.1.007-5, P5 fix-burst); BC-8.3.001 (Idempotency clause; EC-8.3.001-2, P5 fix-burst);
  BC-8.1.008 (project-less not-found message variant, P5 fix-burst).
- **Method:** `WIREMOCK` — one fixture pinning the resolver-layer 404 (resolution GET returns the
  component absent → exit 64, `.expect(0)` on DELETE); a second pinning the race 404 (resolution
  succeeds, DELETE returns 404 → exit 1); assert the exit-code divergence in one test. Fully
  offline. **[P5 fix-burst]** Two further fixture pairs mirror this exact shape for `edit`'s `PUT`
  and `rename`'s `PUT` respectively (resolver/confirming-GET 404 → exit 64, `.expect(0)` on PUT;
  PUT-layer race 404 after successful resolution → exit 1); a message-content assertion on the
  project-less variant's exact text (no `in project <key>` clause) accompanies the numeric
  no-project 404 fixture in each of the three commands.

### 1.3 VP-COMPONENT-025..026 (minted this spec-tightening burst — closes R-2/R-3, §7)

#### VP-COMPONENT-025 — `issue create --component` body composition + resolver mechanism — WIREMOCK
- **Property:** `issue create --component X --component Y` composes
  `fields.components = [{"name":"X"},{"name":"Y"}]` on the `POST /rest/api/3/issue` body
  (object-with-name form, CLI input order, no `add:`/`remove:` prefix interpretation — a literal
  `"add:X"` is sent as a component name and 400s as unknown). Name resolution uses the SAME
  mechanism decision BC-3.4.025 pins: one round-trip via `GET /rest/api/3/project/{key}/components`
  (not editmeta) for name validation; an unknown/ambiguous name → exit 64, `.expect(0)` on the
  create POST. The `--component` + `--request-type` combination guard (BC-3.4.024 Postcondition 3)
  is covered in the same property: exit 64 pre-flight, `.expect(0)` on ALL HTTP (no service-desk
  lookup, no RT-id resolution, no component-list GET).
- **Verifies:** BC-3.4.024 (Postconditions 1–3; EC-3.4.024-1/2/3), BC-3.4.025 (create-path clause
  of the resolution-mechanism decision; Invariant 1's "at most once per question" guarantee).
- **Method:** `WIREMOCK` — body-match asserting the exact `components` array shape for the
  happy-path (analogous to VP-COMPONENT-022's create body-shape discipline); `.expect(0)` on the
  create POST for an unknown/ambiguous name (analogous to VP-COMPONENT-009/013's `.expect(0)`
  posture); `.expect(1)` on the project component-list GET, never duplicated with an editmeta GET
  in the same invocation; a clap/pre-flight `.expect(0)`-on-everything fixture for the
  `--component`+`--request-type` guard. Fully offline.

#### VP-COMPONENT-026 — rename `--all-projects` numeric-`OLD` rejection + exact-equality matching — WIREMOCK/UNIT
- **Property:** Under `--all-projects`, an all-ASCII-digit `OLD` is rejected exit-64 pre-flight
  with `.expect(0)` on BOTH `list_projects` and every per-project component-list GET (zero HTTP of
  any kind). For non-digit `OLD`, per-project matching uses EXACT case-insensitive equality
  (`name.to_lowercase() == OLD.to_lowercase()`) — NOT §8.4's `partial_match` substring semantics —
  so a same-project candidate containing `OLD` as a substring but not equal to it is silently
  skipped (not ambiguous, not renamed).
- **Verifies:** BC-8.3.002 (Precondition 2; Postcondition 1; EC-8.3.002-2/3).
- **Method:** `WIREMOCK` for the numeric-`OLD` `.expect(0)` fixture (zero HTTP, mirroring
  VP-COMPONENT-003/004's `.expect(0)` discipline); `UNIT` for the exact-case-insensitive-equality
  match function, parametrized against a `partial_match`-would-diverge fixture (`"Back"` vs.
  `"Backend"`) asserting the exact-equality function does NOT match while `partial_match` (§8.4)
  would flag it ambiguous or single-substring-resolve it — the divergence itself is the pinned
  property. Fully offline.

### 1.4 VP-COMPONENT-027..028 (minted pass-7 fix-burst — closes MEDIUM-3, §12)

#### VP-COMPONENT-027 — `--label`+`--component` mutual-exclusion exit-64 — WIREMOCK/UNIT
- **Property:** `jr issue edit KEY --label <spec> --component <spec>` (any key count) → the
  Precondition-3 conflict block in BC-3.4.020 fires BEFORE either of that BC's two routing
  paths — exit 64, stderr names both `--label` and the conflicting flag; `.expect(0)` on BOTH
  `PUT /rest/api/3/issue/{key}` (Path A) AND `POST /rest/api/3/bulk/issues/fields` (Path B). This
  is the specific `--component` instantiation of the general 12(+1)-flag conflict block whose
  set-membership completeness EC-3.4.017-14's meta-test already enforces structurally — this VP
  adds the BEHAVIORAL HTTP-arity assertion that member specifically, closing the gap where the
  guard's rationale was documented in prose (BC-3.4.020 Precondition 3) but never independently
  wiremock-pinned.
- **Verifies:** BC-3.4.020 (Precondition 3; the FIX-F5-001-class silent-drop hazard it exists to
  prevent).
- **Method:** `WIREMOCK` — one fixture asserting `.expect(0)` on both the single-key PUT mock and
  the bulk POST mock for `--label add:foo --component add:bar` on one key; a second fixture
  repeats the assertion for 2+ keys (confirming the guard fires identically regardless of the
  routing decision it preempts). `UNIT` — a stderr-content assertion (two separate `contains`
  checks, mirroring EC-3.4.017-14's co-author test pattern: `"--label cannot be combined with"`
  and `"--component"` as independent substrings, not one concatenated string). Fully offline.

#### VP-COMPONENT-028 — dry-run `plannedChanges.components` flat-array shape — WIREMOCK/UNIT
- **Property:** `jr issue edit KEY --component add:X --component remove:Y --dry-run --output
  json` → `plannedChanges.components == [{"action":"ADD","name":"X"},{"action":"REMOVE","name":"Y"}]`
  (flat array, the SAME simplified-preview convention BC-3.4.021 Invariant 1 documents for
  `labels`) — NOT BC-3.4.022's live single-key `update`-verb shape, NOT BC-3.4.023's live bulk
  `multiselectComponents`/integer-`componentId` shape. `--output table` renders `"  components →
  add:X, remove:Y"`. Neither `PUT /rest/api/3/issue/{key}` nor `POST /rest/api/3/bulk/issues/fields`
  is called in either output mode.
- **Verifies:** BC-3.4.021 (EC-3.4.021-20; Invariant 1's "intentionally simplified, non-live-shape
  preview" principle, extended to `components`).
- **Method:** `WIREMOCK` — body-match on the JSON preview (mirrors VP-DRY-RUN-003's assertion
  shape for `labels`, the direct structural precedent); `.expect(0)` on both the single-key PUT
  mock and the bulk POST mock. `UNIT` — a table-mode stdout-content assertion for the
  `"  components → add:X, remove:Y"` line. Fully offline.

---

## 2. Method summary

| Method | VPs |
|--------|-----|
| WIREMOCK (integration, deterministic) | 001, 002, 003, 004, 005, 008, 009, 010, 011, 013, 016, 017, 018, 019, 022, 023, 024, 025, 026, 027, 028 |
| INTEGRATION (subprocess + stdin/TTY seam) | 006, 007 (007 needs the debug-only TTY seam) |
| UNIT | 015 (+ optional proptest), 020 (serde), 026 (exact-equality match fn, shares WIREMOCK fixture set), 027 (stderr-content assertion, shares WIREMOCK fixture set), 028 (table-mode stdout assertion, shares WIREMOCK fixture set) |
| PROPTEST + UNIT (pure-function resolver) | 014, 021 (021 shares 014's suite) |
| WIREMOCK **+ LIVE-JIRA required** | 012 |
| KANI | *(none — all properties are HTTP-shape / call-arity / string-composition / pure-function assertions best covered by wiremock/proptest/unit; no VP warrants a model-checked proof)* |

**Live-Jira requirement:** exactly **one** VP — **VP-COMPONENT-012** (bulk wire shape, DEC-280) —
requires a live-Jira smoke gate. Every other VP, including all six newly-formalized VPs
(021/022/023/024 from the H3 refresh, plus 025/026 from this spec-tightening burst, plus
027/028 from the pass-7 fix-burst, §12) plus 014, is fully offline-dischargeable. VP-COMPONENT-007
needs the debug-only TTY seam but no network.

---

## 3. BC ↔ VP mapping consistency assertion

**Every VP-COMPONENT-001..028 maps to a real BC with a single authoritative definition — the run
is gapless and collision-free, and no duplicate-id definition remains.** Verified against the
current BC bodies:

- **No gaps:** 001..028 all present in BC `**Verification Properties**:` subsections (§0.1 map;
  025/026 minted the spec-tightening burst, §7; 027/028 minted the pass-7 fix-burst, §12).
- **No duplicate definitions:** the former double-014 is resolved — 014 is defined once (BC-8.4.001),
  021 once (BC-8.4.005). VP-015's five appearances in bc-2 are references to ONE property spanning
  five BCs, not five definitions. VP-025's two appearances (BC-3.4.024, BC-3.4.025) are likewise
  references to ONE property spanning two BCs, not two definitions.
- **Every new/modified COMPONENT BC that asserts a testable HTTP-shape / arity / resolver / serde
  property carries ≥1 VP:** BC-8.1.003→001; BC-8.1.005→022; BC-8.1.006→002; BC-8.1.007→004,023,024;
  BC-8.2.001→003; BC-8.2.002→004; BC-8.2.005→005; BC-8.2.006→006,007; BC-8.2.007→017;
  BC-8.2.008→024; BC-8.3.001→004,024; BC-8.3.002→026; BC-8.3.003→018; BC-8.3.004→008;
  BC-8.3.006→019; BC-8.4.001→014; BC-8.4.003→009; BC-8.4.004→010; BC-8.4.005→021;
  BC-2.1.007/018/019/020/021→015; BC-2.1.022→013; BC-2.3.040→020; BC-3.4.022→011,016;
  BC-3.4.023→012; BC-3.4.024→025; BC-3.4.025→025; **BC-3.4.017→VP-396-005 (base, non-`VP-COMPONENT-*`
  namespace — see §0.1's P7 note); BC-3.4.020→027; BC-3.4.021→VP-DRY-RUN-001/002/003,
  VP-692-001..004 (base, pre-existing) + 028 (new, the `components` key specifically).** **[UPDATED
  2026-08-15, P6 fix-burst — resolves MEDIUM-2 found by adversarial spec-delta review pass 6]**
  BC-8.1.007→004,023,024 and BC-8.3.001→004,024 are ADDED here: pass-5's fix-burst (§10) extended
  VP-COMPONENT-004 and VP-COMPONENT-024 to cover BC-8.1.007's M1 numeric-source project-derivation
  and Idempotency sections, and BC-8.3.001's M1 numeric-`OLD` project-confirmation and Idempotency
  sections (both BC bodies carry explicit `**Verification Properties**:` bullets citing VP-004/024,
  §1.1), but this mapping list was never re-synced to reflect that extension — the exact
  drift class §7's "no stale references remain" claim (below) was meant to prevent, now
  corrected. **[UPDATED 2026-08-15, P7 fix-burst — resolves MEDIUM-3 found by adversarial
  spec-delta review pass 7]** BC-3.4.017, BC-3.4.020, and BC-3.4.021 are ADDED here for the first
  time: these three base bc-3 BCs were amended by the `--component` feature (issue #605 F2) but
  neither appeared in this has-VP enumeration NOR in the "deliberately WITHOUT a VP" list below —
  making §3's "every property-bearing BC has ≥1 VP or documented exception" completeness claim
  literally false for three BCs. BC-3.4.017's `components` Gate-B extension was already covered by
  the pre-existing base VP-396-005 (silently un-cited here); BC-3.4.020's `--label`+`--component`
  silent-drop guard and BC-3.4.021's dry-run `components` preview shape had NO VP at all (neither
  base nor `VP-COMPONENT-*`) — closed by minting VP-COMPONENT-027/028 (§1.4, §12).

**BCs deliberately WITHOUT a VP (not inconsistencies — no independently-testable
property beyond a sibling VP or a server-authoritative passthrough):** BC-8.1.001/002 (table/JSON
display), BC-8.1.004 & BC-8.3.005 (clap/config exit-64 guards, covered by ordinary arg-parse
tests), BC-8.1.008 (numeric-bypass/not-found taxonomy, covered by cross-reference to VP-014/VP-009
— R-1, resolved by explicit in-body citation rather than a dedicated VP, §7), BC-8.2.003/004
(delete-specific instantiations of VP-004/VP-009/VP-010), BC-8.3.007 & BC-8.1.005 EC-1 &
BC-8.1.007 EC-2 (server-authoritative 400 passthrough), BC-8.4.002 (unknown-name shape, covered
by VP-009/013 error paths). **[CORRECTED 2026-08-15, P6 fix-burst — resolves MEDIUM-2 found by
adversarial spec-delta review pass 6]** BC-8.3.001 is REMOVED from this list — it is no longer
VP-less as of pass-5's fix-burst (§10): it now carries VP-COMPONENT-004 (numeric-`OLD`
project-mismatch confirmation, EC-8.3.001-1) and VP-COMPONENT-024 (resolver-404-vs-race-404
taxonomy, EC-8.3.001-2) bullets in its own `**Verification Properties**:` subsection. **Previous
version (superseded, retained for audit trail):** "BC-8.3.001 (degenerate `edit --name`,
covered structurally by VP-008/019 patterns)" — this rationale was accurate before pass-5 added
BC-8.3.001's own M1 mechanism (a NEW numeric-`OLD` project-confirmation check, not merely a
degenerate case of `edit --name`) and its own VP citations; it was never updated after that
change landed.

---

## 4. Residual inconsistencies / coverage observations for the product-owner

These are the only items remaining after the H3 correction. None blocked F3; all were
spec-completeness nits for PO judgement. The prior revision's I-2..I-6 "coverage gap" entries were
RETRACTED (those VPs are minted); I-1 was RESOLVED (already narrowed in the BC body). R-1/R-2/R-3
below are CLOSED as of this same-day spec-tightening burst (§7); R-5 is CLOSED as of the pass-7
fix-burst (§12); R-4 remains open/advisory.

- **R-1 (minor — BC-8.1.008 has no VP subsection) — CLOSED, cross-reference (no dedicated VP
  minted):** BC-8.1.008 (unknown `NAME|ID` taxonomy + numeric bypass on `edit`/`delete`) mints no
  VP of its own. Its numeric-bypass behavior IS pinned transitively by VP-COMPONENT-014's property
  statement (all-digit → no candidate fetch), and its unknown-name exit-64 by VP-009/BC-8.4.002.
  Decision (product-owner, this burst): accept the transitive coverage as sufficient rather than
  mint a duplicate pin — `resolve_component` is a single shared function and BC-8.1.008 introduces
  no resolution logic distinct from what VP-014/VP-009 already exercise. BC-8.1.008 now carries an
  explicit `**Verification Properties**:` subsection citing VP-014/VP-009 by name and stating this
  decision inline, closing the traceability nicety without inflating the VP count.

- **R-2 (minor — `issue create --component` path under-pinned) — CLOSED, VP-COMPONENT-025 minted:**
  BC-3.4.024 (`issue create --component X --component Y` sets the initial components array on
  POST) and BC-3.4.025 (`--component` name resolution round-trip on `list`/`create` vs.
  editmeta-gated on `edit`) previously carried no `**Verification Properties**:` subsection.
  VP-COMPONENT-025 now pins both: the create-path initial-array POST body shape (BC-3.4.024) and
  the create-path resolution mechanism, including the editmeta-vs-component-list-GET "answering
  different questions" distinction (BC-3.4.025). Both BC bodies now cite VP-COMPONENT-025. WIREMOCK,
  fully offline.

- **R-3 (minor — rename `--all-projects` numeric-`OLD` rejection has no VP) — CLOSED,
  VP-COMPONENT-026 minted:** BC-8.3.002's H4 fix-burst added a pre-flight exit-64 for an all-digit
  `OLD` under `--all-projects` (EC-8.3.002-2), and its exact-case-insensitive-equality fan-out
  matching (EC-8.3.002-3, divergent from §8.4 `partial_match`). VP-COMPONENT-026 now pins both:
  the numeric-`OLD` `.expect(0)`-on-all-HTTP rejection, and the exact-equality-vs-`partial_match`
  divergence via a dedicated match-function fixture. BC-8.3.002 now cites VP-COMPONENT-026.
  WIREMOCK/UNIT, fully offline.

- **R-4 (advisory — no ARCH-INDEX, still open):** `verification-architecture/ARCH-INDEX.md` is
  absent; there is no central VP registry to keep in sync. If one is later introduced, seed it from
  §0.1's 001..028 map.

- **R-5 (minor — BC-3.4.017/020/021 missing from §3's completeness claim) — CLOSED, one VP
  cited + two VPs minted, pass-7 fix-burst:** found by adversarial spec-delta review pass 7
  (MEDIUM-3). These three base bc-3 BCs, each amended by the `--component` feature (issue #605
  F2), appeared in NEITHER §3's has-VP enumeration NOR its "deliberately WITHOUT a VP" exception
  list — making the completeness claim false for three BCs simultaneously. Disposition per BC:
  BC-3.4.017's `components` Gate-B extension (EC-3.4.017-15) was ALREADY pinned by the
  pre-existing base VP-396-005 (updated in-place at issue #605 F2 to enumerate `components` as
  the fifth field) — no new VP needed, §3 now cites it explicitly. BC-3.4.020's `--label`+
  `--component` mutual-exclusion exit-64 guard (Precondition 3) had NO VP at all — closed by
  minting VP-COMPONENT-027 (§1.4). BC-3.4.021's dry-run `plannedChanges.components` flat-array
  shape (EC-3.4.021-20) had NO VP at all — the BC's existing VPs (VP-DRY-RUN-001/002/003,
  VP-692-001..004) cover description/label/parent/points previews but none exercises the
  `components` key specifically — closed by minting VP-COMPONENT-028 (§1.4). Both new VPs are
  WIREMOCK/UNIT, fully offline.

---

## 5. Live-Jira validation callout (F4/F6 gating)

- **VP-COMPONENT-012 (BC-3.4.023 bulk wire shape) — LIVE-JIRA REQUIRED (DEC-280).** The
  `multiselectComponents` / integer-`componentId` shape is documented + triple-corroborated but
  never observed against a live run (research §Q2.4). Wiremock proves only that `jr` emits the
  documented shape. **[SCOPED 2026-08-15, pass-10 fix-burst — resolves MEDIUM-1 found by
  adversarial spec-delta review pass 10]** Before shipping the bulk path, F4/F6 MUST run a live
  smoke test of **1×ADD, 1×REMOVE across ≥2 issues in one project**, async task polled to success,
  mirroring the `FIX-BULK-TRANSITION-001`/#446 discipline — scoped to the two operations `jr`
  actually emits (Postcondition 3: bare `--component X` → ADD; mixed `add:`+`remove:` → two
  sequential POSTs, ADD then REMOVE). `REPLACE`/`REMOVE_ALL` are wire-schema-completeness enum
  values the endpoint accepts but `jr` has no `set:`/`replace:`/`clear:` CLI grammar to generate
  them with — they are intentionally OUT of scope for this smoke test (do NOT add such a grammar
  to close this gap; that is `#607` territory). **Previous version (superseded, retained for audit
  trail):** "F4/F6 MUST run a live smoke test (1×ADD, 1×REMOVE, 1×REPLACE across ≥2 issues in one
  project, async task polled to success)" — mandated a REPLACE call `jr` never issues. A live
  contradiction on the ADD/REMOVE shape requires correcting BC-3.4.023 + this VP to the observed
  shape. Reuse existing bulk-poll machinery (`JR_BULK_AWAIT_TIMEOUT_SECS`, unknown-status grace) —
  no new polling mechanism.
- **None of VP-COMPONENT-021/022/023/024/025/026/027/028 needs live validation** — all eight are
  offline-dischargeable (021 pure-function proptest/unit; 022/023/024/025 wiremock body-match +
  exit-code assertions; 026 wiremock `.expect(0)` + unit match-function fixture; 027 wiremock
  `.expect(0)` on both PUT and bulk-POST mocks + unit stderr-content assertion; 028 wiremock
  body-match on the JSON preview + unit table-mode stdout assertion). Every other minted VP is
  likewise offline; VP-COMPONENT-007 needs the debug-only TTY seam (`JR_STDIN_IS_TTY`) but no
  network.

---

## 6. Concise summary

- **H3 corrected:** the prior "VP-014..020 not minted / I-2..I-6 coverage gap" claim is FALSE and
  retracted. **VP-COMPONENT-001..024 were ALL minted in the BC bodies as of the H3 refresh**
  (§0.1 map); **the run is now 001..028 after the spec-tightening burst (§7) and the pass-7
  fix-burst (§12).**
- **Newly formalized at the H3 refresh:** VP-014 (canonical resolver determinism + numeric bypass —
  **proptest+unit**, mutants candidate), VP-021 (case-insensitive `ExactMultiple`/JQL agreement —
  **proptest+unit**, shares 014's suite), VP-022 (create POST body omit-if-absent/enum —
  **wiremock**), VP-023 (edit partial PUT, `--lead ""`→`leadAccountId:null` — **wiremock**), VP-024
  (delete 404 taxonomy, resolver-64 vs race-1 — **wiremock**). VP-020 corrected to
  `id: Option<String>` (id-present AND id-absent, M8).
- **Newly formalized this spec-tightening burst:** VP-025 (`issue create --component` body
  composition + resolver mechanism, spanning BC-3.4.024/025 — **wiremock**), VP-026 (rename
  `--all-projects` numeric-`OLD` rejection + exact-equality matching, BC-8.3.002 —
  **wiremock/unit**). See §7.
- **Newly formalized pass-7 fix-burst:** VP-027 (`--label`+`--component` mutual-exclusion
  exit-64, BC-3.4.020 — **wiremock/unit**), VP-028 (dry-run `plannedChanges.components`
  flat-array shape, BC-3.4.021 — **wiremock/unit**). See §12.
- **Mapping is CONSISTENT:** gapless 001..028, one authoritative definition each, no duplicate-id
  definitions (double-014 resolved via VP-021 split), every property-bearing component BC has ≥1 VP
  (including base bc-3 BCs amended by the `--component` feature — BC-3.4.017 cites the pre-existing
  base VP-396-005, BC-3.4.020/021 cite the new VP-027/028).
- **Residuals for PO:** R-1/R-2/R-3 CLOSED §7 — R-1 by explicit cross-reference (no dedicated
  VP), R-2/R-3 by minting VP-025/VP-026. R-5 CLOSED §12 — VP-396-005 cited for BC-3.4.017; VP-027/028
  minted for BC-3.4.020/021. R-4 (no ARCH-INDEX) remains open/advisory.
- **Live-Jira:** exactly one VP — **VP-COMPONENT-012** (bulk wire shape, DEC-280).
  VP-021/022/023/024/025/026/027/028 are all offline-dischargeable.

---

## 7. Spec-tightening burst (2026-08-15, same day) — R-1/R-2/R-3 closed

This burst closes the three residual VP-coverage gaps flagged in §4, ahead of adversarial pass 2,
so the spec delta carries no dangling verification gaps into that review. No new BCs were created;
BC count is unchanged. No formal-verifier re-analysis was performed beyond the residuals
themselves — this is a targeted, mechanical close-out of exactly R-1/R-2/R-3.

- **R-2 closed — VP-COMPONENT-025 minted**, spanning BC-3.4.024 (create-path body composition)
  and BC-3.4.025 (resolver-mechanism decision). Both BC bodies now carry a
  `**Verification Properties**:` subsection citing VP-COMPONENT-025. WIREMOCK, fully offline.
- **R-3 closed — VP-COMPONENT-026 minted**, covering BC-8.3.002's numeric-`OLD` rejection under
  `--all-projects` and its exact-case-insensitive-equality fan-out matching (divergent from §8.4
  `partial_match`). BC-8.3.002 now cites VP-COMPONENT-026. WIREMOCK/UNIT, fully offline.
- **R-1 closed — cross-reference only, no dedicated VP.** BC-8.1.008 now carries a
  `**Verification Properties**:` subsection explicitly citing VP-COMPONENT-014 (numeric-bypass
  path) and VP-COMPONENT-009 (not-found/ambiguous path) as its transitive coverage, with the
  decision rationale stated inline in the BC body. Judgement: `resolve_component` is a single
  shared function; BC-8.1.008 introduces no resolution logic distinct from what VP-014/VP-009
  already exercise, so a dedicated pin would duplicate rather than add coverage.
- **§0.1 map, §1 (new §1.3), §2 method table, §3 mapping assertion, §5 live-Jira callout, and §6
  concise summary above are all updated in this same edit to reflect the `001..026` run** — no
  stale count references remain in this document, AS OF THIS BURST (§7). **[CORRECTED
  2026-08-15, P6 fix-burst — resolves MEDIUM-2 found by adversarial spec-delta review pass 6]**
  This claim was accurate when written but did not age well: it describes §3's state as of THIS
  (§7) burst only, not as a standing invariant that later bursts automatically preserve. Pass-5's
  fix-burst (§10) extended VP-COMPONENT-004/024 to two additional BC homes (BC-8.1.007,
  BC-8.3.001) without re-touching §3, leaving §3 stale from that point until this pass-6 burst
  re-synced it (see §3's own P6 correction and the new §11 below). Read this bullet as scoped to
  §7's own edit, not as an ongoing guarantee — §3 requires re-verification whenever a later
  burst extends an existing VP to a new BC home, not only when a VP is minted or a BC is added.
- **Verification (this burst):** `scripts/check-spec-counts.sh` and
  `scripts/check-bc-cumulative-counts.sh` both exit 0 post-edit (699 total BCs, unchanged — see
  the burst's task-level confirmation).

---

## 8. Pass-3 fix-burst (2026-08-15, same day) — five VPs EXTENDED in place, none minted

This burst responds to adversarial spec-delta review pass 3 (1 HIGH, 2 MEDIUM, 6 LOW, 1 INFO;
persisted verbatim at
`.factory/phase-f2-spec-evolution/adversarial-spec-delta-review-components-p3.md`). All five
touched VPs are pre-existing ids (§0.1) — none is renumbered, none is retired, and no new VP is
minted. The `001..026` run is unchanged. This section records exactly what changed and why; the
full property text lives inline at each VP's entry in §1.1/§1.2 (already updated above).

- **VP-COMPONENT-017 EXTENDED (H1):** the fail-closed rule is now explicit that it covers the
  JRACLOUD-95368 anti-loop drift guard's `has_more=true` PARTIAL, successful return — not only a
  transport-level `Err` — and the pinned JQL clause gains a mandatory trailing `ORDER BY key
  ASC` (pagination-stability rationale, CLAUDE.md `/search/jql` cursor-pagination Gotcha). A
  dedicated anti-loop-drift wiremock fixture is added to the Method. Resolves H1 (safety-critical
  silent-undercount gap on an irreversible delete).
- **VP-COMPONENT-004 EXTENDED (M1):** the numeric-`--move-to`-TARGET confirmation mechanism
  (M2 fix-burst) is now joined by a symmetric numeric-SOURCE confirmation: a numeric source
  `NAME|ID` fires the same confirming `GET`, and a `--project KEY` mismatch against that GET's
  `project` field exits 64 pre-flight, `.expect(0)` on the `--move-to` resolution GET AND
  `DELETE`. A dedicated wiremock fixture is added. Resolves M1 (cross-project `--move-to`
  mis-scoping when the DELETE's own SOURCE positional is numeric).
- **VP-COMPONENT-006 EXTENDED (L3):** now additionally asserts the non-interactive `--yes`-absent
  exit-64 message contains the real, snapshot-derived `<N>` — confirming the BC-8.2.007 snapshot
  fires before this check, not only before the interactive prompt. Resolves L3.
- **VP-COMPONENT-019 EXTENDED (L6):** now additionally covers the `--all-projects` fan-out
  (exact-equality matching, not `partial_match`) with a dedicated two-project wiremock fixture,
  closing a coverage gap where the no-short-circuit rule was pinned only for the single-project
  `partial_match` path. Resolves L6.
- **VP-COMPONENT-012 CORRECTED (I1, wording only):** the `>1000 issues` restatement now says
  `ceil(N/1000)` PER ACTION / `2 * ceil(N/1000)` for a mixed add:+remove: invocation, matching
  BC-3.4.023 Postcondition 6 verbatim — the prior restatement omitted the per-action multiplier.
  No property or test-count change; wording-only correction.

**BC-side companion edits (product-owner, same burst, not part of this formal-verifier doc):**
BC-8.2.007 (H1: ORDER BY + anti-loop fail-closed), BC-8.2.002/003/005 and BC-8.4.001 (M1:
numeric-source confirmation), BC-3.4.023 Invariant 2 (M2: citation fix, no VP impact),
BC-8.2.001/002/006 (L1/L3: documented exceptions + firing-order clarifications), BC-3.4.012/013/021
(L2: bare-`--component` echo normalization pin, no VP impact — **[CORRECTED 2026-08-15, P6
fix-burst — resolves LOW-2 found by adversarial spec-delta review pass 6]** the `components`
field-echo string (BC-3.4.012/013's stderr/JSON `field → value` display and its bare→`add:`
normalization) is DELIBERATELY VP-less, per this codebase's display-echo convention (human/JSON
echo strings are not independently wiremock-pinned — see e.g. the BC-3.4.012/013 description
asymmetry precedent, CLAUDE.md); it is NOT "covered by" VP-COMPONENT-011/016, which pin the
`PUT`/bulk WIRE BODY shape only (the bytes sent to Jira), not the display string shown to the
user or embedded in `--output json`'s echo. **Previous version (superseded, retained for audit
trail):** "covered by existing VP-COMPONENT-011/016 body-shape assertions, not a new VP" — this
conflated wire-body coverage with display-echo coverage, two different properties; VP-011/016
say nothing about the echo string), BC-2.3.040 (L4: honest
no-in-cycle-consumer framing, no VP impact), BC-3.4.023 EC-4 (L5: reworded + partial-chunk
reporting specified, no VP impact beyond VP-012's wording above), BC-8.3.006/002 (L6: see
VP-COMPONENT-019 above).

- **Verification (this burst):** `scripts/check-spec-counts.sh` and
  `scripts/check-bc-cumulative-counts.sh` both exit 0 post-edit (699 total BCs, unchanged).

---

## 9. Pass-4 fix-burst (2026-08-15, same day) — one VP EXTENDED, two VPs re-synced, none minted

This burst responds to adversarial spec-delta review pass 4 (1 HIGH, 1 MEDIUM, 4 LOW, 2 INFO;
persisted verbatim at
`.factory/phase-f2-spec-evolution/adversarial-spec-delta-review-components-p4.md`). All touched
VPs are pre-existing ids (§0.1) — none is renumbered, none is retired, and no new VP is minted.
The `001..026` run is unchanged. This section records exactly what changed and why; the full
property text lives inline at each VP's entry in §1.1 (already updated above).

- **VP-COMPONENT-002 EXTENDED (MEDIUM-1):** this formalization record previously omitted
  BC-8.1.006's own H2-fix-burst extension of VP-002 to cover `create --lead ""`
  (EC-8.1.006-3) — a definition divergence between this doc and the BC body, exactly the class
  of drift INFO-2 (§8, carried forward) flags as structurally unguarded. §1.1's VP-COMPONENT-002
  entry now cites EC-8.1.006-3 and adds the corresponding zero-resolver-HTTP wiremock fixture to
  the Method. §0.1's one-line subject (`--lead resolve never partially mutates`) still covers this
  case without needing edits — the divergence was in §1.1's Verifies/Method detail only, not the
  map row. Resolves MEDIUM-1.
- **VP-COMPONENT-004 / VP-COMPONENT-006 re-synced (LOW-1, BC-side scope broadening, no property
  redefinition):** BC-8.2.002 M1's numeric-source `--project`-mismatch confirmation `GET` — until
  this burst scoped to fire only when `--move-to` is the chosen disposition — now fires for
  EITHER chosen disposition (`--move-to` OR `--orphan`), closing a silent-orphan gap
  (`jr component delete 20007 --project A --orphan --yes` on a numeric id actually belonging to
  project B previously proceeded unchecked). VP-COMPONENT-004's §1.1 entry gains a scope note
  pointing to VP-COMPONENT-006 for the `--orphan`-side assertion (the `--move-to`-side wiremock
  fixture VP-004 already documented is unchanged); VP-COMPONENT-006's own property text is
  unchanged in substance (still "non-interactive `--orphan` without `--yes` → zero `DELETE`") but
  its BC home (BC-8.2.006) gained a new Precondition 4/EC-8.2.006-5 pinning the same mismatch
  check for `--orphan`, so this doc's §0.1/§1.1 entries are updated to stay in sync with that BC
  content rather than silently drifting the way VP-002 did. No VP is renumbered or resplit. Also
  addressed: the mismatch check remains explicitly flag-only (does not separately check a
  `.jr.toml` configured default project) — documented as a deliberate, low-risk limitation in
  BC-8.2.002 M1 itself (the confirming `GET`'s `project` field is authoritative for scoping
  regardless of what `--project`/config says, so a config-default mismatch cannot cause incorrect
  `--move-to` scoping, only a missed early warning); no VP or test-fixture change follows from
  this, since there is no behavior to pin beyond what VP-004/006 already cover for the flag case.
  Resolves LOW-1.
- **HIGH-1 (BC-8.1.004 numeric-ID exemption) and LOW-4 (BC-8.2.001 DEC-188 mechanism-note
  parity) are BC-body-only corrections with NO VP impact** — no property text in this doc
  changes for either. HIGH-1 resolves a contradiction about WHETHER a project/config is required
  before `edit`/`delete`'s numeric-bypass resolution runs (a precondition-ordering question, not
  a new HTTP-call-arity assertion — VP-COMPONENT-014's "zero resolver GET fired for a numeric id"
  pin already covers the resolver-level behavior this exemption enables). LOW-4 adds an explicit
  DEC-188 mechanism note to BC-8.2.001 Postcondition 3, mirroring BC-8.3.005's existing note — a
  documentation-parity fix with no behavioral or property change (the exit-code-64-vs-2 split was
  already correct and already covered by BC-8.2.001's own Postcondition 1/2 language; DEC-188
  itself, not any VP in this doc, is the mechanism-class authority).

**BC-side companion edits (product-owner, same burst, not part of this formal-verifier doc):**
BC-8.1.004 (HIGH-1: numeric-ID exemption for `edit`/`delete`, new EC-8.1.004-6/7/8), BC-8.1.008
EC-8.1.008-1 (HIGH-1: cross-reference note), BC-8.2.001 EC-8.2.001-4 (HIGH-1: cross-reference
note) and Postcondition 3 (LOW-4: DEC-188 mechanism note), BC-8.2.002 M1 (LOW-1: scope broadened
to `--orphan`, config-default limitation documented), BC-8.2.006 (LOW-1: new Precondition 4,
EC-8.2.006-5), BC-3.4.012 (LOW-2: "byte-for-byte across three surfaces" claim scoped to exclude
dry-run JSON, per the pre-existing H1 array-vs-string type asymmetry). LOW-3 (ADR-0018 staleness)
is OUT OF SCOPE for this burst — owned by the architect, concurrent work, not touched here.

- **Verification (this burst):** `scripts/check-spec-counts.sh` and
  `scripts/check-bc-cumulative-counts.sh` both exit 0 post-edit (699 total BCs, unchanged).

---

## 10. Pass-5 fix-burst (2026-08-15, same day) — two VPs EXTENDED in place, none minted

This burst responds to adversarial spec-delta review pass 5 (0 CRIT, 0 HIGH, 1 MEDIUM, 3 LOW, 3
INFO; persisted verbatim at
`.factory/phase-f2-spec-evolution/adversarial-spec-delta-review-components-p5.md`). Both touched
VPs are pre-existing ids (§0.1) — neither is renumbered, neither is retired, and no new VP is
minted. The `001..026` run is unchanged. This section records exactly what changed and why; the
full property text lives inline at each VP's entry in §1.1/§1.2 (already updated above).

- **Unifying decision:** for a NUMERIC-id `edit` and a NUMERIC `OLD` on `rename`, `jr` now fires
  the SAME confirming `GET /rest/api/3/component/{id}` that `delete`'s numeric-source path
  already uses (BC-8.2.002 M1), to (1) confirm the id exists and (2) derive its actual project.
  The derived project is used for `--lead` assignable-user resolution (`edit`) and for
  `invalidate_components_cache(profile, project_key)` (ADR-0018 §2, all numeric mutations); a
  supplied `--project KEY` mismatching the derived project → exit 64, symmetric with `delete`.
  This single decision resolves MED-1, LOW-1, and LOW-3 facet-2 together, since all three trace
  to the same root cause: `edit`'s `NAME|ID` and `rename`'s `OLD` were the only two numeric-bypass
  caller-side usages that had NOT yet gained the confirming-GET mechanism `delete`'s SOURCE and
  `--move-to` TARGET already had (BC-8.2.002 M1, M1 pass-3/pass-4 fix-bursts).
- **VP-COMPONENT-004 EXTENDED (MED-1, LOW-1):** the numeric-source/target confirming-GET
  project-confirmation property (canonical home BC-8.2.002) now has FOUR caller-side
  instantiations instead of two: `delete` SOURCE, `delete --move-to` TARGET (both pre-existing),
  plus `edit`'s `NAME|ID` (new, BC-8.1.007 M1) and `rename`'s `OLD` (new, BC-8.3.001 M1). §1.1's
  VP-COMPONENT-004 entry gains the P5 extension note and two additional wiremock-fixture
  citations (EC-8.1.007-4, EC-8.3.001-1). Resolves MED-1 (edit `--lead`/cache had no project
  source for a numeric no-project `edit`) and LOW-1 (`rename --project A` on a numeric `OLD`
  belonging to project B was previously silently accepted).
- **VP-COMPONENT-024 EXTENDED (LOW-3):** the delete-side resolver-404-vs-race-404 exit-code
  taxonomy (canonical home BC-8.2.008) is now UNIFORM across `edit`'s `PUT` and `rename`'s `PUT`
  too — each command's own BC carries an Idempotency section stating the identical two-tier rule
  (confirming-GET/resolver 404 → exit 64; mutating-call 404 after a successful resolution → exit
  1) rather than leaving edit/rename's races unspecified or inconsistently coded. This also folds
  in the message-composition half of LOW-3 (facet 2): BC-8.1.008's not-found message previously
  assumed a project key was always available to compose `"...not found in project <key>..."`; it
  now has an explicit project-less variant for the case where the ONLY call that could have
  derived a project is the very confirming `GET` that 404'd (numeric `edit`/`delete`/`rename`
  with no `--project`/config supplied). BC-8.2.001 EC-8.2.001-4's "DOES discover the
  non-existence" clause (previously unspecified as to exit code) is also tightened to name the
  exit code and message shape explicitly (exit 64, project-less variant, zero mutating calls).
- **LOW-2 (ADR-0018 §1 staleness) is OUT OF SCOPE for this burst** — owned by the architect,
  concurrent work, not touched here (same disposition as pass-4's LOW-3, its prior incarnation).
- **INFO-1/2/3** are advisory/process-gap/F4-note items with no VP or BC-body change required this
  burst.

**BC-side companion edits (product-owner, same burst, not part of this formal-verifier doc):**
BC-8.1.004 (case 3 exemption text corrected for `edit`'s project-derivation and `rename`'s new
mismatch mechanism; EC-8.1.004-6 updated), BC-8.1.006 (new "Target project for numeric `edit`"
note), BC-8.1.007 (new M1 numeric-source project-derivation section, Precondition 3/Postcondition
3, EC-8.1.007-3/4/5, new Idempotency section, VP-COMPONENT-004/024 bullets), BC-8.1.008 (message
composition corrected to a two-branch rule with a project-less variant, EC-8.1.008-3, Trace
updated), BC-8.2.001 (EC-8.2.001-4's "DOES discover" clause given an explicit exit code/message),
BC-8.2.003 (EC-8.2.003-2's stale "`edit`/`rename OLD` unaffected" claim corrected), BC-8.3.001
(new M1 numeric-`OLD` project-confirmation section, Precondition 3/Postcondition 3,
EC-8.3.001-1/2, new Idempotency section, VP-COMPONENT-004/024 bullets), BC-8.4.001 (Scoped
exception paragraph corrected — all four numeric-bypass caller-side usages now listed, Trace
updated).

**Stories affected by BC changes:** none identified this burst — bc-8-components.md is still
pre-implementation (`src/cli/component.rs` cited throughout as "pending F4"); no story file
currently references BC-8.1.007/BC-8.1.008/BC-8.2.001/BC-8.2.003/BC-8.3.001/BC-8.4.001 to
anchor-back to. Story-writer's `bc_array_changes_propagate_to_body_and_acs` obligation does not
apply here — this is a pre-story-decomposition spec-delta pass.

- **Verification (this burst):** `scripts/check-spec-counts.sh` and
  `scripts/check-bc-cumulative-counts.sh` both exit 0 post-edit (699 total BCs, unchanged).

---

## 11. Pass-6 fix-burst (2026-08-15, same day) — §3 re-synced, one LOW-2 wording fix, no VPs minted or extended

This burst responds to adversarial spec-delta review pass 6 (0 CRIT, 1 HIGH, 2 MEDIUM, 2 LOW, 2
INFO; persisted verbatim at
`.factory/phase-f2-spec-evolution/adversarial-spec-delta-review-components-p6.md`). No VP
property text changes in this burst — both findings addressed here (MEDIUM-2, LOW-2) are
documentation-drift corrections within THIS doc, not BC-body or VP-definition changes. The
`001..026` run is unchanged; no VP is renumbered, retired, extended, or minted.

- **MEDIUM-2 closed — §3 re-synced:** §3's "Every new/modified COMPONENT BC…carries ≥1 VP"
  mapping list gains BC-8.1.007→004,023,024 and BC-8.3.001→004,024 (both extensions actually
  landed in §10's pass-5 fix-burst but were never reflected back into §3's mapping list); §3's
  "BCs deliberately WITHOUT a VP" list drops BC-8.3.001, whose "covered structurally by
  VP-008/019 patterns" rationale predates pass-5's addition of BC-8.3.001's own M1 mechanism and
  its own VP-004/024 citations. §7's closing claim that "no stale references remain in this
  document" is annotated to clarify it described §7's own edit only, not a standing guarantee —
  see §7's P6 correction and §3's own P6 correction for the full account.
- **LOW-2 closed — wording-only correction in §8:** the pass-3 fix-burst's BC-side companion-edit
  list (§8) mischaracterized the `components` field-echo display string (BC-3.4.012/013) as
  "covered by existing VP-COMPONENT-011/016 body-shape assertions." VP-011/016 pin the
  `PUT`/bulk WIRE BODY shape only; the human/JSON echo string and its bare→`add:` normalization
  are a DIFFERENT property, deliberately left unpinned per this codebase's display-echo
  convention (echo strings are not independently wiremock-pinned elsewhere in this codebase
  either). §8 now states this explicitly rather than implying VP-011/016 coverage that does not
  exist.
- **HIGH-1 (BC-8.1.004 rename mis-scoping), the ordering half of MEDIUM-1 (BC-8.1.007/8.1.008/
  8.3.001 not-found message overlap), and LOW-1 (bc-2 reserved-syntax collisions) are BC-body-only
  corrections with NO VP impact** — no property text in this doc changes for any of the three.
  HIGH-1 and MEDIUM-1 are precondition-ordering/message-branch-selection corrections, not new
  HTTP-call-arity assertions (VP-COMPONENT-004/024's existing `.expect(0)`/exit-code pins already
  cover the underlying mechanism; only WHICH message string is emitted, and WHETHER `rename`
  routes through this BC's guard at all, changed). LOW-1 documents an escape-hatch gap
  (unreachable literal component names under reserved `--component` syntax) with a workaround,
  the same shape as the pre-existing `none`-keyword gap (EC-2.1.020-4) — no new testable property,
  just documentation of an existing, accepted limitation.
- **INFO-1 (BC-8.1.007 numeric-edit-no-fields ordering)** is a BC-body-only Precondition-ordering
  clarification (new EC-8.1.007-7) with no VP impact — VP-COMPONENT-023's existing PUT-body-arity
  pin is unaffected by which precondition check fires first when both would independently reject
  the same input.

**BC-side companion edits (product-owner, same burst, not part of this formal-verifier doc):**
BC-8.1.004 (HIGH-1: title/Behavior/exclusion-case-2 corrected to remove `rename` from the
config-fallback model entirely; EC-8.1.004-2 scoped to list/edit/delete), BC-8.1.007 (MEDIUM-1:
M1/Precondition ordering note/EC-8.1.007-6/7 for not-found message branch selection and
zero-HTTP no-fields ordering), BC-8.1.008 (MEDIUM-1: not-found message rule corrected to key off
KNOWN-project-by-any-source rather than which call 404s), BC-8.3.001 (MEDIUM-1: M1/
EC-8.3.001-2 corrected to always use the project-qualified message), BC-2.1.019/021 (LOW-1: new
EC-2.1.019-3/EC-2.1.021-3 documenting `not:`/`all:`/comma reserved-syntax collisions).

**Stories affected by BC changes:** none identified this burst — same rationale as §9/§10
(bc-8-components.md and bc-2-issue-read.md's `--component` filter BCs are still pre-
implementation; no story file currently anchors to any of the touched BCs).

- **Verification (this burst):** `scripts/check-spec-counts.sh` and
  `scripts/check-bc-cumulative-counts.sh` both exit 0 post-edit (699 total BCs, unchanged).

---

## 12. Pass-7 fix-burst (2026-08-15, same day) — two VPs MINTED (027/028), one base VP cited, §3 re-synced

This burst responds to adversarial spec-delta review pass 7 (0 CRIT, 0 HIGH, 3 MEDIUM, 1 LOW, 5
INFO; persisted verbatim at
`.factory/phase-f2-spec-evolution/adversarial-spec-delta-review-components-p7.md`). Two new VPs
are minted this burst (VP-COMPONENT-027, VP-COMPONENT-028) — the run extends from `001..026` to a
complete, gapless, collision-free `001..028`. MEDIUM-1 and LOW-1 are BC-body-only corrections
with NO VP impact; MEDIUM-2 is a `prd-delta-components.md`-only correction, entirely outside this
doc's scope.

- **MEDIUM-3 closed — VP-COMPONENT-027/028 minted, VP-396-005 cited:** §3's "every
  property-bearing component BC has ≥1 VP or documented exception" completeness claim was false —
  BC-3.4.017, BC-3.4.020, and BC-3.4.021 (three base bc-3 BCs amended by the `--component`
  feature, issue #605 F2) appeared in neither the has-VP enumeration nor the "deliberately WITHOUT
  a VP" exception list. Disposition, per BC: BC-3.4.017's `components` Gate-B extension
  (EC-3.4.017-15) was already pinned by the pre-existing base **VP-396-005** (updated in-place at
  issue #605 F2 to enumerate `summary`/`description`/`issuetype`/`priority`/`components` as its
  five-member set) — no new VP; §3 now cites it explicitly, and §0.1 gains an explanatory note on
  why this one property intentionally sits outside the `VP-COMPONENT-*` namespace. BC-3.4.020's
  `--label`+`--component` mutual-exclusion exit-64 guard (Precondition 3, a FIX-F5-001-class
  silent-data-loss guard) had genuinely no VP at all — closed by minting **VP-COMPONENT-027**
  (§1.4), cited in BC-3.4.020's own `**Verification Properties**:` subsection. BC-3.4.021's
  dry-run `plannedChanges.components` flat-array shape (EC-3.4.021-20) had genuinely no VP at
  all — the BC's existing VPs (VP-DRY-RUN-001/002/003, VP-692-001..004) cover the
  description/label/parent/points previews but none exercises the `components` key — closed by
  minting **VP-COMPONENT-028** (§1.4), cited in BC-3.4.021's own `**Verification Properties**:`
  list alongside the pre-existing entries. §0.1, §1 (new §1.4), §2, §3, §4 (new R-5), §5, and §6
  are all updated in this same edit to reflect the `001..028` run.
- **MEDIUM-1 (BC-8.1.008 NAME-path message over-reach) is a BC-body-only correction with NO VP
  impact:** BC-8.1.008's former branch (1) enumerated a NAME `NAME|ID` alongside a numeric
  `NAME|ID` with a known project, assigning the NAME sub-case the SAME message as the numeric
  sub-case — but BC-8.4.002 (zero-match) and BC-8.4.003 (ambiguous) each specify a DIFFERENT
  message shape (`"...Available: <list>."` / `"Ambiguous...Matches: <candidates>."`), so a NAME
  resolution failure on `edit`/`delete` would have emitted a message inconsistent with the shared
  `resolve_component` call's other consumers (`issue list --component`, BC-2.1.022). This is a
  message-branch-SELECTION correction, not a new HTTP-call-arity assertion — VP-COMPONENT-009's
  existing `.expect(0)` pin (ambiguous/unknown name → zero mutating HTTP) already covers the
  underlying mechanism regardless of which message string is emitted; only WHICH message BC-8.1.008
  cites for a NAME input changed (now deferring verbatim to BC-8.4.002/003 rather than restating).
- **LOW-1 (BC-8.3.002/8.3.004 numeric-`OLD`-vs-`--dry-run` ordering) is a BC-body-only
  clarification with NO VP impact:** the pre-flight numeric-`OLD` exit-64 rejection under
  `--all-projects` (BC-8.3.002 Precondition 2) already implies it fires before ANY HTTP, including
  the per-project discovery loop `--dry-run` would otherwise preview — but this ordering was
  never stated as an explicit edge case for the `--dry-run` combination specifically.
  VP-COMPONENT-026's existing `.expect(0)`-on-all-HTTP pin (numeric-`OLD` rejection) and
  VP-COMPONENT-008's existing `.expect(0)`-on-`PUT` pin (`--dry-run` zero mutation) already jointly
  cover this combination's HTTP-call-arity — no new property, just an explicit EC naming the
  ordering.
- **MEDIUM-2 (prd-delta-components.md L53/L164 stale post-P6) is entirely outside this doc's
  scope** — `prd-delta-components.md` is a product-owner-owned F2 artifact, not a
  formal-verifier/VP-formalization artifact; no line in `verification-delta-components.md`
  needed correction for MEDIUM-2. Recorded here only for completeness against the pass-7 finding
  list.

**BC-side companion edits (product-owner, same burst, not part of this formal-verifier doc):**
BC-8.1.008 (MEDIUM-1: Behavior rewritten to split a new branch (0) for NAME-path resolution
failures, deferring to BC-8.4.002/003 verbatim; new EC-8.1.008-4; Trace updated to cite
BC-8.4.002/003/BC-2.1.022), BC-3.4.020 (MEDIUM-3: new VP-COMPONENT-027 bullet in Verification
Properties), BC-3.4.021 (MEDIUM-3: new VP-COMPONENT-028 bullet appended to the existing
Verification Properties list), BC-8.3.002 (LOW-1: new EC-8.3.002-4), BC-8.3.004 (LOW-1: new
EC-8.3.004-2), `prd-delta-components.md` (MEDIUM-2: L53 and L164 corrected — outside this doc's
scope, recorded for cross-reference only).

**Stories affected by BC changes:** none identified this burst — same rationale as §9/§10/§11
(bc-8-components.md and bc-3-issue-write.md's `--component`-touched BCs are still
pre-implementation; no story file currently anchors to any of the touched BCs).

- **Verification (this burst):** `scripts/check-spec-counts.sh` and
  `scripts/check-bc-cumulative-counts.sh` both exit 0 post-edit (699 total BCs, unchanged — VPs
  are not subject to the BC count gate).
