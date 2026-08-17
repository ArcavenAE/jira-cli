## PR Review — S-604-2 (`jr component create` / `jr component edit`)

**Verdict: APPROVE**
**covered_sha:** `9439b3c3eb0099ed79b9baa5eaefdfe8ffb95f2a`

Reviewed the full diff (7 code/test files + 16 demo-evidence artifacts) against the 18
acceptance criteria in the story spec. No blocking findings. One MAJOR spec-fidelity
item and six MINOR items are listed below; none prevents merge.

---

### Critical checks — all 5 PASS

**1. No-fields guard precedes resolver AND confirming GET (AC-010 / AC-011)** — PASS
`has_fields` is evaluated as the first statement after destructuring `EditComponentArgs`,
before the `is_numeric_id` fork. Neither `get_component` (numeric path) nor
`list_components` (name path) can fire. Zero HTTP on the guard path for both input shapes,
as AC-010 and AC-011 each require.

**2. PUT race 404 propagates as ApiError → exit 1 (AC-016 / VP-COMPONENT-024)** — PASS
`edit_component` → `put_json` → `send`, which maps non-401 4xx to
`JrError::ApiError { status, message }` (`src/api/client.rs:1051`). The `?` at the
`edit_component` call site performs no downcast and no remap. The 404→`UserError`
downcast exists *only* on the confirming-GET arm, so the two 404 classes are correctly
distinguished: resolver 404 → exit 64, PUT race 404 → exit 1.

**3. Create body built with conditional inserts only (AC-003 / VP-COMPONENT-022)** — PASS
`serde_json::Map` is seeded with `name` and `project`, then three independent
`if let Some(...)` inserts for `description`, `leadAccountId`, and `assigneeType`. No
`Value::Null` is reachable anywhere on the create path — the only `Null` insert in the
file is `handle_edit`'s deliberate `--lead ""` clear (AC-009).

**4. `handle_list` remains unmodified (no S-604-1 behavior changed)** — PASS
The sole edit to the list path is deletion of the `let _ = resolve_component;`
unused-import suppressor that S-604-1 added as a placeholder, now genuinely consumed by
`handle_edit`. Zero behavioral change to the merged S-604-1 list path.

**5. `invalidate_components_cache` called after both mutations (AC-018 / ADR-0018 §2)** — PASS
`cache::invalidate_components_cache(&config.active_profile_name, &project)` after
`create_component().await?`; the same call with `&project_key` after
`edit_component().await?`. Both sit after the successful await and before output, so a
failed mutation never invalidates the cache.

---

### Findings

| Severity | Category | Location | Finding |
|---|---|---|---|
| MAJOR | spec-fidelity | `src/cli/mod.rs::AssigneeType` | `ValueEnum` accepts kebab-case only; spec AC-002's literal command uses `PROJECT_LEAD` and exits 2 |
| MINOR | coherence | `src/cli/mod.rs::ComponentSubcommand` | `allow_hyphen_values` on `--description` but not on `NAME` / `--name` |
| MINOR | missing | (repo root) | No CHANGELOG entry for two new user-facing subcommands |
| MINOR | correctness | `src/cli/component.rs::handle_edit` | `MatchResult::ExactMultiple` collapsed into `Exact`, then first-match `find` |
| MINOR | correctness | `src/cli/component.rs::handle_edit` | Numeric path fail-open when `--project` supplied *and* GET returns no `project` |
| MINOR | spec-fidelity | `src/cli/component.rs::handle_edit` | No-fields guard message wording vs AC-010/011 quoted text |
| MINOR | UX | `src/cli/component.rs::handle_edit` | Edit table mode emits echo lines only, no confirmation line |
| COSMETIC | duplication | `src/cli/component.rs` | ~25-line lead-resolution block duplicated between create and edit |

---

#### MAJOR — `--assignee-type` value spelling diverges from the spec's own command literal

`#[derive(clap::ValueEnum)]` on `AssigneeType` carries no `#[value(...)]` attributes, so
clap's default kebab-case renaming applies. The captured `--help` output in
`docs/demo-evidence/S-604-2/evidence-report.md` confirms the accepted values are
`component-lead`, `project-lead`, `unassigned`, `project-default`.

AC-002 specifies, verbatim:

```
jr component create --project FOO Backend --description "d" --lead alice --assignee-type PROJECT_LEAD
```

That exact command exits 2 today. The wire value is correct — `assignee_type_to_api_str`
emits `PROJECT_LEAD` — so this is a CLI-surface divergence, not an API-contract defect.
It matters because Jira's own API documentation uses `PROJECT_LEAD`, so users will
naturally type the form that fails.

Worth noting for traceability: the AC-002 test does not exercise the AC's literal
command. Per the evidence report it pins `assigneeType: "COMPONENT_LEAD"` on the wire,
meaning it invokes `component-lead` — so the test passes green while the command the AC
actually documents does not work. That is an AC/test divergence, not a test defect.

**Suggestion** — one line, either direction:

```rust
#[derive(clap::ValueEnum, Clone, Debug)]
#[value(rename_all = "SCREAMING_SNAKE_CASE")]
pub enum AssigneeType { ... }
```

or add `#[value(alias = "PROJECT_LEAD")]` (etc.) per variant to accept both spellings.
The alias form is preferable if kebab-case is the established house style for
`ValueEnum` flags elsewhere in this CLI, since it keeps both the idiomatic and the
Jira-documented spelling working.

#### MINOR — `allow_hyphen_values` inconsistency on free-text write inputs

`--description` carries `allow_hyphen_values = true` on both `Create` and `Edit`, but the
`Create` `NAME` positional and `Edit --name` do not. A component named `-legacy` can
therefore be neither created nor renamed. CLAUDE.md's convention applies
`allow_hyphen_values` to user-authored free-text write inputs (`--summary`,
`--description`, comment bodies, `--title`); `--name` is free text of exactly that kind.
`--lead` is arguably a lookup key rather than free text and is reasonably excluded.

**Suggestion** — add `#[arg(allow_hyphen_values = true)]` to `Edit --name` and to the
`Create` `NAME` positional, and note the missing-value tradeoff (documented in CLAUDE.md
under the `allow_hyphen_values` entry) if that is a concern for the positional.

#### MINOR — no CHANGELOG entry

Zero `CHANGELOG` hits in the diff, for a change that adds two new user-facing
subcommands. Repo practice includes CHANGELOG rows for user-visible changes.

#### MINOR — `MatchResult::ExactMultiple` collapsed into the `Exact` arm

```rust
MatchResult::Exact(n) | MatchResult::ExactMultiple(n) => n,
```

followed by `components.into_iter().find(|c| c.name == matched_name)` means that when
several components share an exact name, the first in list order is silently selected and
mutated. This is unreachable if Jira enforces per-project component-name uniqueness; if
it does not, it is a silent wrong-target mutation on a write command.

**Suggestion** — either split `ExactMultiple` into its own arm returning an exit-64
disambiguation error, or add a comment recording *why* the variant is unreachable here so
the next reader does not have to re-derive it.

#### MINOR — numeric path fail-open corner

```rust
if let Some(ref user_project) = project {
    if !derived_project.is_empty() && !user_project.eq_ignore_ascii_case(&derived_project) {
```

When `--project WRONG` is supplied *and* the confirming GET returns no `project` field,
the mismatch check is skipped and `WRONG` becomes both the lead-resolution project and
the cache-invalidation key. The F-07 fail-closed guard immediately above only fires when
no `--project` was supplied. Narrow (requires Jira to omit `project` on a 200 GET), but
the asymmetry is worth an explicit comment or a fail-closed extension.

#### MINOR — no-fields guard message wording

AC-010 and AC-011 quote `"no fields specified"`; the implementation emits
`"No fields to update. Supply --name, --description, or --lead."`. Neither AC tags this
as verbatim (contrast AC-015, which explicitly says "BC-8.4.002's verbatim message"), so
this is probably fine — but confirm against BC-8.1.007 Precondition 1's literal text.
The implemented message is the better one for users; if the BC's text differs, prefer
amending the BC over degrading the message.

#### MINOR — edit table mode has no confirmation line

`handle_edit`'s table branch emits only `  field → value` echo lines. A user running
`jr component edit Backend --name New` sees `  name → New` and nothing stating that the
change was persisted — asymmetric with create's
`Created component "<name>" (id <id>) in project <key>.`. Consistent with the BC-3.4.012
echo convention borrowed from `issue edit`, so likely intentional, but the asymmetry
between two sibling subcommands in the same file is worth a second look.

#### COSMETIC — duplicated lead-resolution block

The ~25-line 0 / 1 / ambiguous match block (including the email + accountId candidate
listing) is duplicated verbatim between `handle_create` and `handle_edit`. A shared
`resolve_lead_account_id(client, query, project) -> Result<String>` helper would remove
the risk of the two copies' message strings drifting apart, which matters here because
those strings are spec-pinned by BC-8.1.006 / BC-X.7.004.

---

### Also verified

- **Demo evidence** — `docs/demo-evidence/S-604-2/` contains 5 `.gif` + 5 `.webm` +
  5 `.tape` + `evidence-report.md`. Both success and error paths are recorded (clap
  exit 2, exit 64 ×2, plus two `--help` surface captures). Satisfies the demo-evidence
  checklist item; no `.txt` placeholders.
- **JSON render invariant (#526)** — both new `--output json` paths route through
  `output::render_json`. No direct `serde_json::to_string_pretty` and no compact
  `json!` Display printing.
- **Output channels** — symmetric profile 4 applied consistently on both new paths
  (JSON → stdout, human → stderr).
- **Description accuracy** — PR body's traceability table, architecture diagram, and
  ADR-0018 summary match the actual diff. The claimed file set matches
  `gh pr diff --name-only`.
- **Diff size** — large in aggregate, but implementation is ~500 LOC in
  `src/cli/component.rs` plus ~35 LOC in `src/api/jira/components.rs` and ~20 LOC in
  `src/api/client.rs`; the remainder is tests and binary demo artifacts. Reasonable for
  two new subcommands with 18 ACs.
- **Dependency status** — S-604-1 reported merged at `e2c403e8`; the diff builds on its
  `resolve_component` / `list_components` / `invalidate_components_cache` surface without
  modifying it.
- **Commit quality** — conventional format with story ID
  (`feat(components): jr component create and jr component edit (S-604-2)`).

### Recommendation

Merge. Address the MAJOR `--assignee-type` value-spelling item either in a follow-up
commit on this branch or as a fast-follow story — it is a one-line clap attribute and
does not warrant blocking a purely additive feature whose wire contract is already
correct.
